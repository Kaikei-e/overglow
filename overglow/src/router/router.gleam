import gleam/string_builder
import wisp.{type Request, type Response, html_response}

pub type Context {
  Context(secret: String)
}

pub fn handle_request(request: Request) -> Response {
  use req <- middleware(request)

  case wisp.path_segments(req) {
    [] ->
      string_builder.from_string("<h1>Hello from overglow!</h1>")
      |> html_response(200)
    _ -> wisp.not_found()
  }
}

pub fn middleware(
  request: Request,
  handle_request: fn(wisp.Request) -> wisp.Response,
) {
  let req = wisp.method_override(request)
  use <- wisp.log_request(req)
  use <- wisp.rescue_crashes
  use req <- wisp.handle_head(req)

  handle_request(req)
}
