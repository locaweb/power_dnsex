defmodule PowerDNSex.Models.Error do
  defstruct [:error]

  @type t :: %__MODULE__{error: String.t}
end
