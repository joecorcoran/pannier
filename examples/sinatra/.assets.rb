mount   '/assets'

input  'assets'
output 'public'

package :styles do
  assets '*.css'
  env? 'production' do
    concat 'main.min.css'
  end
end
