# require 'system'
require 'io/console'

class Model # crunchs numbers
  def initialize
    @expression = '' # store expression values
  end

  def evaluate # evaluate expression

  end

  def getExpression
    @expression
  end

  def handleInput(value)
    case value
      when 'c'
        @expression = ''
      when '=','\r'
        self.evaluate
      else
        @expression += value
    end
  end

  def clearValues
    @expresion = []
  end
end

class Controller # handles input
  def initialize(model, view)
    @calcModel = model
    @calcView = view

    @validChars = ['1','2','3','4','5','6','7','8','9','0','+','-','*','(',')','%','/','.','=','\r','q','c']
    @exitChars = ['q']
    @state = 'init'
  end

  def step

    # get input character
    inputChar = STDIN.getch

    # exit on exit char press
    if @exitChars.include?(inputChar)
      @state = 'stopped'
      @calcView.exitMessage
      exit
    end

    # validate input
    isValid = @validChars.include?(inputChar)

    if isValid
      @calcModel.handleInput(inputChar)
    end

    @calcView.render(inputChar, isValid, @calcModel.getExpression )

  end

  def start
    @state = 'running'
    while @state != 'stopped'
      step
    end
  end
end

class View # renders calculator
  def initialize
    @clearCmd = Gem.win_platform? ?  "cls" :  "clear"
    @calculatorTop =
'
 ---------------
'
    @calculatorFace =
'|---------------
| ( | ) | % | c |
|---+---+---+---|
| 7 | 8 | 9 | / |
|---+---+---+---|
| 4 | 5 | 6 | * |
|---+---+---+---|
| 1 | 2 | 3 | - |
|---+---+---+---|
| 0 | . | = | + |
 ---------------
'
  end

  def exitMessage
    system @clearCmd
    puts "Exiting..."
  end

  def render(inputChar, isValid, expression) # render view
    system @clearCmd
    print @calculatorTop
    puts '| ' + expression
    print @calculatorFace
    puts "Keypressed: #{inputChar}, was #{isValid ? "valid" : "invalid"}"
  end
end

def main
  calcModel = Model.new
  calcView = View.new
  calcController = Controller.new(calcModel,calcView)
  calcController.start
end

main
