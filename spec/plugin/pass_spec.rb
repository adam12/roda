require_relative "../spec_helper"

describe "pass plugin" do 
  it "skips the current block if pass is called" do
    app(:pass) do |r|
      r.root do
        r.pass if env['FOO'] == 'true'
        'root'
      end

      r.on :id do |id|
        r.pass if id == 'foo'
        id
      end

      r.on :x, :y do |x, y|
        x + y
      end
    end

    body.must_equal 'root'
    status('FOO'=>'true').must_equal 404
    body("/a").must_equal 'a'
    body("/a/b").must_equal 'a'
    body("/foo/a").must_equal 'fooa'
    body("/foo/a/b").must_equal 'fooa'
    status("/foo").must_equal 404
  end
end
