th train.lua -data ~/data/MSCOCO/dataset/ -style_image style.jpg -style_size 600 -image_size 512 -model johnson_small -batch_size 2 -learning_rate 1e-2 -style_weight 10 -style_layers relu1_2,relu2_2,relu3_2,relu4_2 -content_layers relu4_2 -nThreads 8 -add_noise
