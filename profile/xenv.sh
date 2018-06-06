export PATH=$PATH:/app/xenv/bin

if [ "$XENV_UPDATE_ON_BOOT" = "true" ]; then
  xenv
fi
