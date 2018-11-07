require_relative 'simplex_solver/operations/build_tableau'

# require 'awesome_print'

# Simplex Solver
module SimplexSolver
  def self.solve(rules)
    tb = Operations::BuildTableau.new(rules).tableau
  end
end

# MAXIMIZACAO

type = :max

restrictions = [
  [type, 32, 17], # z
  [3, 4, 3], # s1
  [5, 6, 5], # s2
  [7, 8, 7]  # s3
]

# type = :min

# restrictions = [
#   [type, 3, 5, 7], # z
#   [3, 5, 7, 32], # s1
#   [4, 6, 8, 17], # s2
# ]

SimplexSolver.solve(restrictions)
