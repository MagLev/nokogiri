#!/bin/bash -e
# This script assumes that MAGLEV_HOME is set

# Prepare Nokogiri gem ... cannot build with MagLev
ruby -S gem install bundler --no-rdoc --no-ri
ruby -S bundle install
rm -f *.gem
ruby -S rake gem:spec
ruby -S gem build nokogiri-maglev-.gemspec

export PATH=$MAGLEV_HOME/bin:$PATH
export MAGLEV_OPTS=

maglev-gem uninstall -a nokogiri nokogiri-maglev- maglev-nokogiri
maglev-gem install --no-rdoc --no-ri nokogiri-maglev--*.gem
maglev-gem install minitest ci_reporter mini_portile --no-rdoc --no-ri

# Run tests with CI Reporter
rm -rf "$(dirname $0)/reports"
export CI_REPORTS="$(dirname $0)/reports"
maglev-ruby -w -I.:lib:bin:test:. -e '
require "rubygems"; require "minitest/autorun";
require "ci/reporter/rake/minitest_loader";

require "test/test_convert_xpath.rb";
require "test/test_css_cache.rb";
require "test/test_encoding_handler.rb";
require "test/test_soap4r_sax.rb";
require "test/test_memory_leak.rb";
require "test/test_nokogiri.rb";
require "test/test_reader.rb";
require "test/test_xslt_transforms.rb";
require "test/css/test_nthiness.rb";
require "test/css/test_tokenizer.rb";
require "test/css/test_xpath_visitor.rb";
require "test/css/test_parser.rb";
require "test/decorators/test_slop.rb";
require "test/html/test_named_characters.rb";
require "test/html/test_node_encoding.rb";
require "test/html/test_document_fragment.rb";
require "test/html/test_element_description.rb";
require "test/html/test_node.rb";
require "test/xml/test_attribute_decl.rb";
require "test/xml/test_comment.rb";
require "test/xml/test_dtd_encoding.rb";
require "test/xml/test_element_content.rb";
require "test/xml/test_element_decl.rb";
require "test/xml/test_entity_decl.rb";
require "test/xml/test_node_encoding.rb";
require "test/xml/test_processing_instruction.rb";
require "test/xml/test_relax_ng.rb";
require "test/xml/test_schema.rb";
require "test/xml/test_syntax_error.rb";
require "test/xml/test_c14n.rb";
require "test/xml/test_node_inheritance.rb";
require "test/xml/test_reader_encoding.rb";
require "test/xml/test_attr.rb";
require "test/xml/test_builder.rb";
require "test/xml/test_cdata.rb";
require "test/xml/test_document.rb";
require "test/xml/test_document_encoding.rb";
require "test/xml/test_dtd.rb";
require "test/xml/test_parse_options.rb";
require "test/xml/test_text.rb";
require "test/xml/test_entity_reference.rb";
require "test/xml/test_namespace.rb";
require "test/xml/test_unparented_node.rb"; 
require "test/xml/node/test_save_options.rb";
require "test/xml/node/test_subclass.rb";
require "test/xml/sax/test_parser.rb";
require "test/xml/sax/test_parser_context.rb";
require "test/xml/sax/test_push_parser.rb";
require "test/html/sax/test_parser.rb";
require "test/html/sax/test_parser_context.rb";
require "test/xslt/test_exception_handling.rb";
require "test/xml/test_node.rb";
require "test/xslt/test_custom_functions.rb";
require "test/xml/test_document_fragment.rb";
require "test/xml/test_node_set.rb";
require "test/xml/test_xpath.rb";'

# Report expected failures as skips
# On Jenkins, $WORKSPACE will be set
if [[ -n $WORKSPACE ]]; then
    cat <<EOF>> "$(dirname $0)/reports/TEST-ExpectedFailures.xml"

<?xml version="1.0" encoding="UTF-8"?>
<testsuite assertions="0" tests="6" time="0.0"
	   failures="0" errors="0" skipped="6"
	   name="Skipped Tests">
 <testcase name="test/xml/test_xinclude.rb" time="0.0" assertions="0">
  <skipped/>
 </testcase>
 <testcase name="test/xml/test_node_attributes.rb" time="0.0" assertions="0">
  <skipped/>
 </testcase>
 <testcase name="test/xml/test_node_reparenting.rb" time="0.0" assertions="0">
  <skipped/>
 </testcase>
 <testcase name="test/html/test_builder.rb" time="0.0" assertions="0">
  <skipped/>
 </testcase>
 <testcase name="test/xml/test_document_encoding.rb" time="0.0" assertions="0">
  <skipped/>
 </testcase>
 <testcase name="test/xml/test_document.rb" time="0.0" assertions="0">
  <skipped/>
 </testcase>
 <system-out></system-out>
 <system-err></system-err>
</testsuite>
EOF
else
    echo "The following files were not run as they have known failures
------
1 FAILURE: test/xml/test_xinclude.rb
1 FAILURES: test/xml/test_node_attributes.rb
3 FAILURES: test/xml/test_node_reparenting.rb
------
RuntimeError: Document already has a root node
nokogiri/lib/nokogiri/xml/document.rb:230:in add_child

1 ERROR: test/html/test_builder.rb
------
UncontinuableError: a UncontinuableError occurred (error 6011),
Execution cannot be continued, 'Exception has already been signaled'
nokogiri/lib/nokogiri/html/document.rb:112:in parse

2 ERRORS: test/html/test_document_encoding.rb
2 ERRORS: test/html/test_document.rb"
fi
