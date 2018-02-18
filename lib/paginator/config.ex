defmodule Paginator.Config do
  @moduledoc false

  @type t :: %__MODULE__{}

  defstruct [
    :after,
    :after_values,
    :before,
    :before_values,
    :cursor_fields,
    :cursor_module,
    :include_total_count,
    :total_count_primary_key_field,
    :limit,
    :maximum_limit,
    :sort_direction,
    :total_count_limit
  ]

  @default_total_count_primary_key_field :id
  @default_limit 50
  @minimum_limit 1
  @maximum_limit 500
  @default_total_count_limit 10_000
  @default_cursor_module Paginator.Cursors.UnencryptedCursor

  def new(opts \\ []) do
    %__MODULE__{
      after: opts[:after],
      after_values: cursor_module(opts).decode(opts[:after]),
      before: opts[:before],
      before_values: cursor_module(opts).decode(opts[:before]),
      cursor_fields: opts[:cursor_fields],
      cursor_module: cursor_module(opts),
      include_total_count: opts[:include_total_count] || false,
      total_count_primary_key_field: opts[:total_count_primary_key_field] || @default_total_count_primary_key_field,
      limit: limit(opts),
      sort_direction: opts[:sort_direction] || :asc,
      total_count_limit: opts[:total_count_limit] || @default_total_count_limit
    }
  end

  defp cursor_module(opts) do
    opts[:cursor_module] || @default_cursor_module
  end

  defp limit(opts) do
    max(opts[:limit] || @default_limit, @minimum_limit)
    |> min(opts[:maximum_limit] || @maximum_limit)
  end
end
