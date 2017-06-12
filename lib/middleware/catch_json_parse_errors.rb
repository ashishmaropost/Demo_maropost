class CatchJsonParseErrors
  def initialize(app)
    @app = app
  end

  def call(env)
    begin
      @app.call(env)
    rescue ActionDispatch::ParamsParser::ParseError => error
      if env['CONTENT_TYPE'] =~ /application\/xml/
        error_output = "There was a problem in the JSON you submitted: #{error.class}"
        return [
          400, { "Content-Type" => "application/xml" },
          [ { :code => 400, status: "Failure", error: error_output }.to_xml ]
        ]
      else
        raise error
      end
    end
  end
end