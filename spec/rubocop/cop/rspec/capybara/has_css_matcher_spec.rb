# frozen_string_literal: true

RSpec.describe RuboCop::Cop::RSpec::Capybara::HasCssMatcher do
  it 'registers an offense when using has_css? in an or expression' do
    expect_offense(<<~RUBY)
      has_css?(".first") || has_css?(".second")
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `has_css?(".first, .second")` instead of `has_css?(".first") || has_css?(".second")`.
    RUBY

    expect_correction(<<~RUBY)
      has_css?(".first, .second")
    RUBY
  end

  it 'does not register an offense when using a single call to `has_css?`' do
    expect_no_offenses(<<~RUBY)
      has_css?(".foobar")
    RUBY
  end

  it 'does not register an offense when using a AND call to `has_css?`' do
    expect_no_offenses(<<~RUBY)
      has_css?(".foobar") && has_css?(".barfoo")
    RUBY
  end
end
