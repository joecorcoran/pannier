root   '/assets'

input  'assets'
output 'public'

package :styles do
  assets '*.css'
  host 'production' do
    concat 'main.min.css'
  end
end
