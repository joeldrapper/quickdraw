# # frozen_string_literal: true

# class GreenDots::CodeBox
# 	Lexer = Rouge::Lexers::Ruby.new

# 	Formatter = Rouge::Formatters::Terminal256.new(
# 		theme: Rouge::Themes::Base16.mode(:dark)
# 	)

# 	def initialize(code, lineno)
# 		@max_length = code.lines.max_by(&:length).length
# 		@lineno = lineno

# 		@lines = Formatter.format(
# 			Lexer.lex(
# 				code.gsub!(/^(\t+)/) { |match| " " * (match.length * 2) }
# 			)
# 		).lines

# 		@buffer = +""
# 	end

# 	def render
# 		@buffer.clear

# 		cols = `tput cols`.to_i

# 		@buffer << "\e[38;5;8m"
# 		@buffer << ("─" * cols)
# 		@buffer << "\e[0m"

# 		@buffer << "\n"

# 		@lines.each_with_index do |line, lineno|
# 			lineno += 1

# 			next if lineno < @lineno - 3 || lineno > @lineno + 3

# 			@buffer << (" " * (@lines.length.to_s.length - lineno.to_s.length))

# 			@buffer << "\e[38;5;8m"
# 			@buffer << " "
# 			@buffer << lineno.to_s
# 			if lineno == @lineno
# 				@buffer << "\e[38;5;196m"
# 				@buffer << " ⊙  "
# 			else
# 				@buffer << "    "
# 			end

# 			@buffer << "\e[0m"
# 			@buffer << line
# 		end

# 		@buffer << "\e[38;5;8m"
# 		@buffer << ("─" * cols)
# 		@buffer << "\e[0m"
# 	end
# end
