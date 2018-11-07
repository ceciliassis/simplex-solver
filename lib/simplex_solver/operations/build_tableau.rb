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

      private

      def build_tableau(rules)
        rules  = setup_rules(rules)
        z_func = rules[0]
        vars   = z_func.size - 1
        slacks = rules.size - 1 # remove linha z

        setup_lines(slacks, vars)
        build_labels(vars, slacks)
        build_z(z_func)
        build_rules(rules, vars)
      end

      def setup_rules(rules)
        rules[0] << 0
      end

      def setup_lines(slacks, vars)
        @tb = Array.new(slacks + 2) { Array.new(vars + slacks + 2, 0) }
      end

      def build_labels(vars, slacks)
        fl     = @tb[0]
        fl[0]  = ''
        fl[-1] = 'V'

        vars.times { |i| fl[i + 1] = 'x' + (i + 1).to_s }
        slacks.times { |i| fl[vars + i + 1] = 's' + (i + 1).to_s }
      end

      def build_z(z_func)
        z_line    = @tb[1]
        z_line[0] = 'z'
        z_func.each.with_index(1) { |e, i| z_line[i] = (el.zero? ? e : -e) }
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
