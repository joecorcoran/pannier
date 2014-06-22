input  'fixtures/input'
output 'fixtures/output'

package :one do
  input 'one'
  assets '*.css'
  modify do |content, basename|
    ["/* #{basename} */\n#{content}", basename]
  end
  concat 'one.min.css'
end

package :two do
  input 'two'
  assets '*.css'
  modify do |content, basename|
    ["/* deprecated */\n#{content}", basename]
  end
  concat 'two.min.css'
end
