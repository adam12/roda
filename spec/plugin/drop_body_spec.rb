require_relative "../spec_helper"

describe "drop_body plugin" do 
  it "automatically drops body and Content-Type/Content-Length headers for responses without a body" do
    app(:drop_body) do |r|
      response.status = r.path[1, 1000].to_i
      response.write('a')
    end

    [100 + rand(100), 204, 304].each do  |i|
      path = "/#{i.to_s}"
      body(path).must_equal ''
      header('Content-Type', path).must_be_nil
      header('Content-Length', path).must_be_nil
    end

    body('/205').must_equal ''
    header('Content-Type', '/205').must_be_nil
    if Rack.release < '2.0.2'
      header('Content-Length', '/205').must_be_nil
    else
      header('Content-Length', '/205').must_equal '0'
    end

    body('/200').must_equal 'a'
    header('Content-Type', '/200').must_equal 'text/html'
    header('Content-Length', '/200').must_equal '1'
  end
end
