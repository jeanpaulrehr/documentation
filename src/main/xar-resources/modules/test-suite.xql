xquery version "3.1";

(:~ This library module contains XQSuite tests for the documentation app.
 :
 : @author eXist-db
 : @version 1.0.0
 :)

module namespace tests = "http://exist-db.org/xquery/documentation/tests";
declare namespace test = "http://exist-db.org/xquery/xqsuite";

import module namespace docbook = "http://docbook.org/ns/docbook" at "docbook.xql";
import module namespace config = "http://exist-db.org/xquery/apps/config" at "config.xqm";
import module namespace diag = "http://exist-db.org/xquery/diagnostics" at "diagnostics.xql";
import module namespace rvds = "http://exist-db.org/xquery/rvd-support" at "rvd-support.xql";

declare namespace db5 = "http://docbook.org/ns/docbook";

declare
%test:name('section-headings')
%test:assertEmpty
function tests:missing-id() {

    let $no-id := distinct-values(
    for $n in collection($config:data-root)//db5:article/db5:sect1 | collection($config:data-root)//db5:article//db5:sect2 | collection($config:data-root)//db5:article//db5:sect3
    return
        if ($n/@xml:id) then
            ()
        else
            (util:document-name($n))
    )

    for $m in $no-id
        order by $m
    return
        $m
};

declare
%test:name('diagnose listings')
%test:assertEmpty
function tests:orphan-listing() {
  let $report := diag:diagnose(<root/>, map{1: 1})
  let $error := $report//ul//span[. eq '*ERROR* ']
  let $error-msg := count($error)
  let $art := $error/ancestor::li/h3/code/string()
  let $list :=  $error/ancestor::tr//code[1]/string()
  return
    if ($error-msg > 0)
    then ( $list || ' is missing in ' || $art )
    else ()
};
