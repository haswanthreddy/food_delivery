EXCEPTIONS = {
  # 400 Bad Request
  "ActiveRecord::NotNullViolation" => { status: "failure", code: 400, error: "Missing mandatory fields." },
  "ActiveRecord::RecordInvalid" => { status: "failure", code: 400, error: "Invalid request parameters." },
  "BadRequest" => { status: "failure", code: 400, error: "Bad Request: Invalid request parameters." },

  # 401 Unauthorized
  "Unauthorized" => { status: "failure", code: 401, error: "Unauthorized: Authentication required." },

  # 403 Forbidden
  "Forbidden" => { status: "failure", code: 403, error: "Forbidden: Insufficient permissions." },

  # 404 Not Found
  "ActiveRecord::RecordNotFound" => { status: "failure", code: 404, error: "Not Found: Record not found." },
  "NotFound" => { status: "failure", code: 404, error: "Not Found: Resource not found." },

  # 409 Conflict
  "Conflict" => { status: "failure", code: 409, error: "Conflict: Resource conflict." },

  # 422 Unprocessable Entity
  "UnprocessableEntity" => { status: "failure", code: 422, error: "Unprocessable Entity: Validation failed." },

  # 500 Internal Server Error
  "InternalServerError" => { status: "failure", code: 500, error: "Internal Server Error: Something went wrong on the server." }
}