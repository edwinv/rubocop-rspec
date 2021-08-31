# frozen_string_literal: true

module RuboCop
  module Cop
    module RSpec
      module Capybara
        # Check for has_css? calls in an or expression.
        #
        # When the selector is not present on the current page, Capybara waits
        # for the `wait_time` before it returns. By combining the two
        # selectors in one call, there is no wait penalty when the first
        # selector is not matched.
        #
        # @example
        #   # bad
        #   has_css?(".first") || has_css?(".second")
        #
        #   # good
        #   has_css?(".first, .second")
        #
        class HasCssMatcher < Base
          extend AutoCorrector

          MSG = 'Use `has_css?("%<left>s, %<right>s")` instead of' \
                ' `has_css?("%<left>s") || has_css?("%<right>s")`.'

          # @!method has_css_or?(node)
          def_node_matcher :has_css_or?, <<~PATTERN
            (or (`send nil? :has_css? $...) (`send nil? :has_css? $...))
          PATTERN

          def on_or(node)
            expression = has_css_or?(node)
            return unless expression

            add_offense(node, message: message(expression)) do |corrector|
              corrector.replace(node, correction(expression))
            end
          end

          private

          def message(expression)
            lefthand_selector, righthand_selector =
              expression.flatten.map(&:value)

            format(MSG, left: lefthand_selector, right: righthand_selector)
          end

          def correction(expression)
            lefthand_selector, righthand_selector =
              expression.flatten.map(&:value)
            "has_css?(\"#{lefthand_selector}, #{righthand_selector}\")"
          end
        end
      end
    end
  end
end
