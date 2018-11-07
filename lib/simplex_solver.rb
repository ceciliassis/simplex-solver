# frozen_string_literal: true

require 'simplex_solver/utils'
require 'pp'

# Simplex Solver
module SimplexSolver
  class << self
    def solve(rules)
      @tb    = Utils.build_tableau(rules)
      @range = (1..-1)

      run

      print("\n--- ---- Final ---- ---")
      Utils.print_tableau(@tb)
    end

    private

    def run
      while pivot_col.value.negative?
        p_col = pivot_col
        p_row = pivot_row(p_col.index)
        update_pivot_row(p_row)
        update_other_rows(p_col.index, p_row)
        Utils.print_tableau(@tb)
      end
    end

    def pivot_col
      z = @tb[1][1..-2]
      Utils.smallest(z).tap { |e| e.index += 1 }
    end

    def pivot_row(pcol)
      divs = []
      @tb[2..-1].each { |line| divs << (line[-1] / line[pcol]) }

      p_elem       = Utils.smallest(divs, true)
      p_elem_index = p_elem.index + 2
      elem_line    = @tb[p_elem_index]
      elem_line[0] = @tb[0][pcol]

      Element.new(elem_line[pcol], p_elem_index)
    end

    def update_pivot_row(p_row)
      old_row = @tb[p_row.index][@range]
      new_row = old_row.map { |i| i / p_row.value }
      @tb[p_row.index][@range] = new_row
    end

    def update_other_rows(p_col, p_row)
      p_row_index = p_row.index
      pivot_row   = @tb[p_row.index][@range]

      @tb[@range].each.with_index(1) do |row, i|
        next if i == p_row_index

        pivot_coef = @tb[i][p_col]
        row[@range].each.with_index do |el, j|
          row[j + 1] = el - (pivot_coef * pivot_row[j])
        end
      end
    end
  end
end

type = :max

# restrictions = [
#   [type, 32, 17], # z
#   [3, 4, 3],      # s1
#   [5, 6, 5],      # s2
#   [7, 8, 7]       # s3
# ]

_restrictions = [
  [type, 9, 17, 14],  # z
  [30, 65, 20, 2100], # s1
  [65, 63, 80, 660],  # s2
  [19, 7, 2, 480]     # s3
]

path = 'data/matrix.txt'
restrictions = SimplexSolver::Utils.read_from_file(path)

SimplexSolver.solve(restrictions)
