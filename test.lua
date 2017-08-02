require 'nn'
require 'image'
require 'mynn'
require 'src/utils'

local cmd = torch.CmdLine()

cmd:option('-input_image', '', 'Image to stylize.')
cmd:option('-image_size', 0, 'Resize input image to. Do not resize if 0.')
cmd:option('-model_t7', '', 'Path to trained model.')
cmd:option('-save_path', 'stylized.jpg', 'Path to save stylized image.')
cmd:option('-cpu', false, 'use this flag to run on CPU')
cmd:option('-eval', 'false', 'use this flag to run on CPU')

local params = cmd:parse(arg)

-- Load model and set type
local model = torch.load(params.model_t7)

if params.cpu then 
  tp = 'torch.FloatTensor'
else
  require 'cutorch'
  require 'cunn'
  require 'cudnn'

  tp = 'torch.CudaTensor'
  model = cudnn.convert(model, cudnn)
end

model:type(tp)
if params.eval == 'true' then
  print('eval')
  model:evaluate()
else
  print('training')
  model:training()
end

-- Load image and scale
local img = image.load(params.input_image, 3):float()
if params.image_size > 0 then
  img = image.scale(img, params.image_size)
end

local n=  img:clone():uniform()
-- n:div(torch.norm(n)/2)

img = torch.cat( {img,n}, 1)
-- Stylize
local input = img:add_dummy()
local stylized = model:forward(input:type(tp)):double()
stylized = deprocess(stylized[1])

-- Save
image.save(params.save_path, torch.clamp(stylized,0,1))
