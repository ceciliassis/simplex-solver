require 'matrix'

module SimplexSolver
  module Operations
    # BuildTableau
    class BuildTableau
      def initialize(rules)
        @tb = []
        build_tableau(rules)
      end

      def tableau
        @tb
      end

      def self.print_tableau(tableau)
        puts "---- Tableau -----\n\n"
        tableau.each { |line| p line }
      end

      private

      def build_tableau(rules)
        type = rules[0].shift
        rules[0] << 0

        rules = transpose_rules(rules) if type == :min

        z_func = rules[0]
        vars   = z_func.size - 1
        slacks = rules.size - 1 # remove linha z

        setup_lines(slacks, vars)
        build_labels(vars, slacks)
        build_z(z_func)
        build_rules(rules, vars)
      end

      def transpose_rules(rules)
        rules << rules.shift
        rules = Matrix[*rules].transpose.to_a
        rules.unshift(rules.pop)
      end

      def setup_lines(slacks, vars)
        @tb = Array.new(slacks + 2) { Array.new(vars + slacks + 2, 0) }
      end

      def build_labels(vars, slacks)
        first_line = @tb[0]

        first_line[0]  = ''
        first_line[-1] = 'V'

        vars.times do |i|
          first_line[i + 1] = 'x' + (i + 1).to_s
        end

        slacks.times do |i|
          first_line[vars + i + 1] = 's' + (i + 1).to_s
        end
      end

      def build_z(z_func)
        z_line    = @tb[1]
        z_line[0] = 'z'
        z_func.each.with_index(1) do |elem, i|
          z_line[i] = -elem
        end
      end

      def build_rules(rules, vars)
        rules.drop(1).each.with_index(1) do |rule, i|
          line = @tb[i + 1]
          col  = i + vars

          line[0]   = @tb[0][col]
          line[col] = 1
          line[-1]  = rule[-1]

          vars.times { |v| line[v + 1] = rule[v] }
        end
      end
    end
  end
end
