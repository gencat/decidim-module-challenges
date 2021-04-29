# frozen_string_literal: true

class RemoveRequireNullInProblemsForSolutions < ActiveRecord::Migration[5.2]
  def change
    change_column_null :decidim_solutions_solutions, :decidim_problems_problem_id, true
  end
end
