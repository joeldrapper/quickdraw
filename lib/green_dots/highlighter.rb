# frozen_string_literal: true

require "prism"

module TrueColor
	class BaseColor
		def close
			"\e[0m"
		end

		def sample
			self["■"]
		end

		def [](str)
			"#{open}#{str}#{close}"
		end

		def puts(str)
			puts self[str]
		end

		def to_hex
			"##{to_rgb.map { |c| c.to_s(16).rjust(2, '0') }.join}"
		end

		def to_s
			"rgb(#{to_rgb.join(', ')})"
		end
	end

	class ANSI256Color < BaseColor
		GREYSCALE_THRESHOLD = 25

		RGB_TO_CODE = {
			[0, 0, 0].freeze => 0,
			[128, 0, 0].freeze => 1,
			[0, 128, 0].freeze => 2,
			[128, 128, 0].freeze => 3,
			[0, 0, 128].freeze => 4,
			[128, 0, 128].freeze => 5,
			[0, 128, 128].freeze => 6,
			[192, 192, 192].freeze => 7,
			[128, 128, 128].freeze => 8,
			[255, 0, 0].freeze => 9,
			[0, 255, 0].freeze => 10,
			[255, 255, 0].freeze => 11,
			[0, 0, 255].freeze => 12,
			[255, 0, 255].freeze => 13,
			[0, 255, 255].freeze => 14,
			[255, 255, 255].freeze => 15,
			[0, 0, 0].freeze => 16,
			[0, 0, 95].freeze => 17,
			[0, 0, 135].freeze => 18,
			[0, 0, 175].freeze => 19,
			[0, 0, 215].freeze => 20,
			[0, 0, 255].freeze => 21,
			[0, 95, 0].freeze => 22,
			[0, 95, 95].freeze => 23,
			[0, 95, 135].freeze => 24,
			[0, 95, 175].freeze => 25,
			[0, 95, 215].freeze => 26,
			[0, 95, 255].freeze => 27,
			[0, 135, 0].freeze => 28,
			[0, 135, 95].freeze => 29,
			[0, 135, 135].freeze => 30,
			[0, 135, 175].freeze => 31,
			[0, 135, 215].freeze => 32,
			[0, 135, 255].freeze => 33,
			[0, 175, 0].freeze => 34,
			[0, 175, 95].freeze => 35,
			[0, 175, 135].freeze => 36,
			[0, 175, 175].freeze => 37,
			[0, 175, 215].freeze => 38,
			[0, 175, 255].freeze => 39,
			[0, 215, 0].freeze => 40,
			[0, 215, 95].freeze => 41,
			[0, 215, 135].freeze => 42,
			[0, 215, 175].freeze => 43,
			[0, 215, 215].freeze => 44,
			[0, 215, 255].freeze => 45,
			[0, 255, 0].freeze => 46,
			[0, 255, 95].freeze => 47,
			[0, 255, 135].freeze => 48,
			[0, 255, 175].freeze => 49,
			[0, 255, 215].freeze => 50,
			[0, 255, 255].freeze => 51,
			[95, 0, 0].freeze => 52,
			[95, 0, 95].freeze => 53,
			[95, 0, 135].freeze => 54,
			[95, 0, 175].freeze => 55,
			[95, 0, 215].freeze => 56,
			[95, 0, 255].freeze => 57,
			[95, 95, 0].freeze => 58,
			[95, 95, 95].freeze => 59,
			[95, 95, 135].freeze => 60,
			[95, 95, 175].freeze => 61,
			[95, 95, 215].freeze => 62,
			[95, 95, 255].freeze => 63,
			[95, 135, 0].freeze => 64,
			[95, 135, 95].freeze => 65,
			[95, 135, 135].freeze => 66,
			[95, 135, 175].freeze => 67,
			[95, 135, 215].freeze => 68,
			[95, 135, 255].freeze => 69,
			[95, 175, 0].freeze => 70,
			[95, 175, 95].freeze => 71,
			[95, 175, 135].freeze => 72,
			[95, 175, 175].freeze => 73,
			[95, 175, 215].freeze => 74,
			[95, 175, 255].freeze => 75,
			[95, 215, 0].freeze => 76,
			[95, 215, 95].freeze => 77,
			[95, 215, 135].freeze => 78,
			[95, 215, 175].freeze => 79,
			[95, 215, 215].freeze => 80,
			[95, 215, 255].freeze => 81,
			[95, 255, 0].freeze => 82,
			[95, 255, 95].freeze => 83,
			[95, 255, 135].freeze => 84,
			[95, 255, 175].freeze => 85,
			[95, 255, 215].freeze => 86,
			[95, 255, 255].freeze => 87,
			[135, 0, 0].freeze => 88,
			[135, 0, 95].freeze => 89,
			[135, 0, 135].freeze => 90,
			[135, 0, 175].freeze => 91,
			[135, 0, 215].freeze => 92,
			[135, 0, 255].freeze => 93,
			[135, 95, 0].freeze => 94,
			[135, 95, 95].freeze => 95,
			[135, 95, 135].freeze => 96,
			[135, 95, 175].freeze => 97,
			[135, 95, 215].freeze => 98,
			[135, 95, 255].freeze => 99,
			[135, 135, 0].freeze => 100,
			[135, 135, 95].freeze => 101,
			[135, 135, 135].freeze => 102,
			[135, 135, 175].freeze => 103,
			[135, 135, 215].freeze => 104,
			[135, 135, 255].freeze => 105,
			[135, 175, 0].freeze => 106,
			[135, 175, 95].freeze => 107,
			[135, 175, 135].freeze => 108,
			[135, 175, 175].freeze => 109,
			[135, 175, 215].freeze => 110,
			[135, 175, 255].freeze => 111,
			[135, 215, 0].freeze => 112,
			[135, 215, 95].freeze => 113,
			[135, 215, 135].freeze => 114,
			[135, 215, 175].freeze => 115,
			[135, 215, 215].freeze => 116,
			[135, 215, 255].freeze => 117,
			[135, 255, 0].freeze => 118,
			[135, 255, 95].freeze => 119,
			[135, 255, 135].freeze => 120,
			[135, 255, 175].freeze => 121,
			[135, 255, 215].freeze => 122,
			[135, 255, 255].freeze => 123,
			[175, 0, 0].freeze => 124,
			[175, 0, 95].freeze => 125,
			[175, 0, 135].freeze => 126,
			[175, 0, 175].freeze => 127,
			[175, 0, 215].freeze => 128,
			[175, 0, 255].freeze => 129,
			[175, 95, 0].freeze => 130,
			[175, 95, 95].freeze => 131,
			[175, 95, 135].freeze => 132,
			[175, 95, 175].freeze => 133,
			[175, 95, 215].freeze => 134,
			[175, 95, 255].freeze => 135,
			[175, 135, 0].freeze => 136,
			[175, 135, 95].freeze => 137,
			[175, 135, 135].freeze => 138,
			[175, 135, 175].freeze => 139,
			[175, 135, 215].freeze => 140,
			[175, 135, 255].freeze => 141,
			[175, 175, 0].freeze => 142,
			[175, 175, 95].freeze => 143,
			[175, 175, 135].freeze => 144,
			[175, 175, 175].freeze => 145,
			[175, 175, 215].freeze => 146,
			[175, 175, 255].freeze => 147,
			[175, 215, 0].freeze => 148,
			[175, 215, 95].freeze => 149,
			[175, 215, 135].freeze => 150,
			[175, 215, 175].freeze => 151,
			[175, 215, 215].freeze => 152,
			[175, 215, 255].freeze => 153,
			[175, 255, 0].freeze => 154,
			[175, 255, 95].freeze => 155,
			[175, 255, 135].freeze => 156,
			[175, 255, 175].freeze => 157,
			[175, 255, 215].freeze => 158,
			[175, 255, 255].freeze => 159,
			[215, 0, 0].freeze => 160,
			[215, 0, 95].freeze => 161,
			[215, 0, 135].freeze => 162,
			[215, 0, 175].freeze => 163,
			[215, 0, 215].freeze => 164,
			[215, 0, 255].freeze => 165,
			[215, 95, 0].freeze => 166,
			[215, 95, 95].freeze => 167,
			[215, 95, 135].freeze => 168,
			[215, 95, 175].freeze => 169,
			[215, 95, 215].freeze => 170,
			[215, 95, 255].freeze => 171,
			[215, 135, 0].freeze => 172,
			[215, 135, 95].freeze => 173,
			[215, 135, 135].freeze => 174,
			[215, 135, 175].freeze => 175,
			[215, 135, 215].freeze => 176,
			[215, 135, 255].freeze => 177,
			[215, 175, 0].freeze => 178,
			[215, 175, 95].freeze => 179,
			[215, 175, 135].freeze => 180,
			[215, 175, 175].freeze => 181,
			[215, 175, 215].freeze => 182,
			[215, 175, 255].freeze => 183,
			[215, 215, 0].freeze => 184,
			[215, 215, 95].freeze => 185,
			[215, 215, 135].freeze => 186,
			[215, 215, 175].freeze => 187,
			[215, 215, 215].freeze => 188,
			[215, 215, 255].freeze => 189,
			[215, 255, 0].freeze => 190,
			[215, 255, 95].freeze => 191,
			[215, 255, 135].freeze => 192,
			[215, 255, 175].freeze => 193,
			[215, 255, 215].freeze => 194,
			[215, 255, 255].freeze => 195,
			[255, 0, 0].freeze => 196,
			[255, 0, 95].freeze => 197,
			[255, 0, 135].freeze => 198,
			[255, 0, 175].freeze => 199,
			[255, 0, 215].freeze => 200,
			[255, 0, 255].freeze => 201,
			[255, 95, 0].freeze => 202,
			[255, 95, 95].freeze => 203,
			[255, 95, 135].freeze => 204,
			[255, 95, 175].freeze => 205,
			[255, 95, 215].freeze => 206,
			[255, 95, 255].freeze => 207,
			[255, 135, 0].freeze => 208,
			[255, 135, 95].freeze => 209,
			[255, 135, 135].freeze => 210,
			[255, 135, 175].freeze => 211,
			[255, 135, 215].freeze => 212,
			[255, 135, 255].freeze => 213,
			[255, 175, 0].freeze => 214,
			[255, 175, 95].freeze => 215,
			[255, 175, 135].freeze => 216,
			[255, 175, 175].freeze => 217,
			[255, 175, 215].freeze => 218,
			[255, 175, 255].freeze => 219,
			[255, 215, 0].freeze => 220,
			[255, 215, 95].freeze => 221,
			[255, 215, 135].freeze => 222,
			[255, 215, 175].freeze => 223,
			[255, 215, 215].freeze => 224,
			[255, 215, 255].freeze => 225,
			[255, 255, 0].freeze => 226,
			[255, 255, 95].freeze => 227,
			[255, 255, 135].freeze => 228,
			[255, 255, 175].freeze => 229,
			[255, 255, 215].freeze => 230,
			[255, 255, 255].freeze => 231,
			[8, 8, 8].freeze => 232,
			[18, 18, 18].freeze => 233,
			[28, 28, 28].freeze => 234,
			[38, 38, 38].freeze => 235,
			[48, 48, 48].freeze => 236,
			[58, 58, 58].freeze => 237,
			[68, 68, 68].freeze => 238,
			[78, 78, 78].freeze => 239,
			[88, 88, 88].freeze => 240,
			[98, 98, 98].freeze => 241,
			[108, 108, 108].freeze => 242,
			[118, 118, 118].freeze => 243,
			[128, 128, 128].freeze => 244,
			[138, 138, 138].freeze => 245,
			[148, 148, 148].freeze => 246,
			[158, 158, 158].freeze => 247,
			[168, 168, 168].freeze => 248,
			[178, 178, 178].freeze => 249,
			[188, 188, 188].freeze => 250,
			[198, 198, 198].freeze => 251,
			[208, 208, 208].freeze => 252,
			[218, 218, 218].freeze => 253,
			[228, 228, 228].freeze => 254,
			[238, 238, 238].freeze => 255
		}.freeze

		CODE_TO_RGB = RGB_TO_CODE.invert.freeze

		def initialize(code)
			raise ArgumentError unless self.class::CODE_TO_RGB.key?(code)

			@code = code
			freeze
		end

		def inspect
			"#{self.class.name}(#{@code})"
		end

		def open
			"\e[38;5;#{@code}m"
		end

		def self.rgb_distance(a, b)
			Math.sqrt(
				((a[0] - b[0])**2) +
				((a[1] - b[1])**2) +
				((a[2] - b[2])**2)
			)
		end

		def self.from_rgb(rgb)
			# Lucky exact match
			if (code = self::RGB_TO_CODE[rgb])
				return new(code)
			end

			# Greyscale
			if rgb.max - rgb.min < GREYSCALE_THRESHOLD
				# Get the average shade and reduce to 25 possible shades
				shade = (rgb.sum / 3.0 / 255.0 * 25.0).round

				case shade
				when 0 # black
					return new(0)
				when 25 # white
					return new(15)
				else
					return new(232 + shade)
				end
			end

			r, g, b = rgb

			ansi_r = (r / 255.0 * 5.0).round
			ansi_g = (g / 255.0 * 5.0).round
			ansi_b = (b / 255.0 * 5.0).round

			code = 16 + (ansi_r * (6 * 6)) + (ansi_g * 6) + ansi_b

			new(code)
		end

		def to_true_color
			Color.new(*to_rgb)
		end

		def to_rgb
			self.class::CODE_TO_RGB[@code]
		end
	end

	class Color < BaseColor
		def initialize(r, g, b)
			@r, @g, @b = r, g, b
			freeze
		end

		def inspect
			"#{self.class.name}(#{@r}, #{@g}, #{@b})"
		end

		def open
			"\e[38;2;#{@r};#{@g};#{@b}m"
		end

		def to_ansi_256
			ANSI256Color.from_rgb(to_rgb)
		end

		def to_rgb
			[@r, @g, @b]
		end
	end

	module RoséPine
		Base = Color.new(25, 23, 36)
		Surface = Color.new(31, 29, 46)
		Overlay = Color.new(38, 35, 58)
		Muted = Color.new(110, 106, 134)
		Subtle = Color.new(144, 140, 170)
		Text = Color.new(224, 222, 244)
		Love = Color.new(235, 111, 146)
		Gold = Color.new(246, 193, 119)
		Rose = Color.new(235, 188, 186)
		Pine = Color.new(49, 116, 143)
		Foam = Color.new(156, 207, 216)
		Iris = Color.new(196, 167, 231)
		HighlightLow = Color.new(33, 32, 46)
		HighlightMed = Color.new(64, 61, 82)
		HighlightHigh = Color.new(82, 79, 103)
	end

	RosePine = RoséPine

	module RoséPineMoon
		Base = Color.new(35, 33, 54)
		Surface = Color.new(42, 39, 63)
		Overlay = Color.new(57, 53, 82)
		Muted = Color.new(110, 106, 134)
		Subtle = Color.new(144, 140, 170)
		Text = Color.new(224, 222, 244)
		Love = Color.new(235, 111, 146)
		Gold = Color.new(246, 193, 119)
		Rose = Color.new(234, 154, 151)
		Pine = Color.new(62, 143, 176)
		Foam = Color.new(156, 207, 216)
		Iris = Color.new(196, 167, 231)
		HighlightLow = Color.new(42, 40, 62)
		HighlightMed = Color.new(68, 65, 90)
		HighlightHigh = Color.new(86, 82, 110)
	end

	RosePineMoon = RoséPineMoon

	module RoséPineDawn
		Base = Color.new(250, 244, 237)
		Surface = Color.new(255, 250, 243)
		Overlay = Color.new(242, 233, 222)
		Muted = Color.new(152, 147, 165)
		Subtle = Color.new(121, 117, 147)
		Text = Color.new(87, 82, 121)
		Love = Color.new(180, 99, 122)
		Gold = Color.new(234, 157, 52)
		Rose = Color.new(215, 130, 126)
		Pine = Color.new(40, 105, 131)
		Foam = Color.new(86, 148, 159)
		Iris = Color.new(144, 122, 169)
		HighlightLow = Color.new(244, 237, 232)
		HighlightMed = Color.new(223, 218, 217)
		HighlightHigh = Color.new(206, 202, 205)
	end

	RosePineDawn = RoséPineDawn
end

class GreenDots::Highlighter < Prism::Visitor
	def self.highlight(code)
		new(code).tap do |h|
			h.visit(Prism.parse(code).value)
		end.output
	end

	def initialize(code)
		@code = code.lines
		@offsets = Array.new(code.lines.length, 0)
		super()
	end

	def visit_def_node(node)
		blue node.def_keyword_loc
		red node.name_loc
		super
	end

	def visit_local_variable_write_node(node)
		blue node.name_loc
		super
	end

	def visit_instance_variable_write_node(node)
		blue node.name_loc
		super
	end

	def output
		@code.join.gsub!(/^(\t+)/) { |match| " " * (match.length * 2) }
	end

	def red(loc)
		insert_before loc, "\e[38;5;196m" and insert_after loc, "\e[0m"
	end

	def blue(loc)
		insert_before loc, "\e[38;5;33m" and insert_after loc, "\e[0m"
	end

	def insert_before(loc, str)
		@code[loc.start_line - 1].insert(loc.start_column + @offsets[loc.start_line - 1], str)
		@offsets[loc.start_line - 1] += str.length
	end

	def insert_after(loc, str)
		@code[loc.end_line - 1].insert(loc.end_column + @offsets[loc.end_line - 1], str)
		@offsets[loc.end_line - 1] += str.length
	end
end

binding.irb
