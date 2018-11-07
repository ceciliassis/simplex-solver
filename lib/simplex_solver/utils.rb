# frozen_string_literal: true

Element = Struct.new('Element', :value, :index)

module SimplexSolver
  # Utils
  module Utils
    def self.read_from_file(path)
      rules = []
      File.open(path).each.with_index do |line, i|
        line = line.split.map { |ele| Float(ele) }
        rules << (i.zero? ? [:max, *line] : line)
      end
      rules
    end

    def self.print_tableau(tableau)
      puts
      tableau.each { |l| p l }
      puts
      tableau[1..-1].each { |l| puts "#{l[0]}: #{l[-1]}" }
    end

    def self.build_tableau(rules)
      BuildTableau.new(rules).tableau
    end

    def self.smallest(row, from_divs = false)
      row = row.select(&:positive?) if from_divs
      Element.new(row.min, row.index(row.min))
    end

    #  BuildTableau
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
        setup_rules(rules)

        z_func = rules[0]
        vars   = z_func.size - 1
        slacks = rules.size - 1 # remove linha z

        setup_lines(slacks, vars)
        build_labels(vars, slacks)
        build_z(z_func)
        build_rules(rules, vars)
      end

      def setup_rules(rules)
        rules[0].shift
        rules[0] << 0

        rules.each { |rule| rule.map! { |num| Float(num) } }
      end

      def setup_lines(slacks, vars)
        @tb = Array.new(slacks + 2) { Array.new(vars + slacks + 2, 0.0) }
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
        z_func.each.with_index(1) { |e, i| z_line[i] = (e.zero? ? e : -e) }
      end

      def build_rules(rules, vars)
        rules[1..-1].each.with_index(1) do |rule, i|
          line = @tb[i + 1]
          col  = i + vars

          line[0]   = @tb[0][col]
          line[col] = 1.0
          line[-1]  = rule[-1]

          vars.times { |v| line[v + 1] = rule[v] }
        end
      end
    end
  end
end
