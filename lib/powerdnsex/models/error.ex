defmodule PowerDNSex.Models.Error do
  defstruct [:error, :http_status_code]

  @type t :: %__MODULE__{error: String.t()}
end
