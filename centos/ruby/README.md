##
```bash
#安装flutter
https://storage.googleapis.com/flutter_infra/releases/stable/linux/flutter_linux_1.22.5-stable.tar.xzb
tar xf ~/Downloads/flutter_linux_1.22.5-stable.tar.xz
tar -xf flutter_linux_1.22.5-stable.tar.xz -C /usr/local/
export PATH="$PATH:`pwd`/flutter/bin"
#源码编译安装ruby
https://cache.ruby-lang.org/pub/ruby/3.0/ruby-3.0.0.tar.gz
tar -xf *.tar.gz
./configure --prefix=/usr/local
make -j 4
make install -j 4
gem sources --add https://gems.ruby-china.com/ --remove https://rubygems.org/
gem sources -l
gem install bundle 




```
