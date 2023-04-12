# load custom functions
for f in ~/.config/fish/user/functions/*
  if test -f $f
    source $f
  end
end
