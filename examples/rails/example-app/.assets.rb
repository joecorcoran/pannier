mount  '/assets'

input  'app/assets'
output "public/#{env.name}"
logger

package :styles do
  input 'stylesheets'
  assets 'one.css', 'two.css'
  env? 'production' do
    concat 'main.min.css'
  end
end
