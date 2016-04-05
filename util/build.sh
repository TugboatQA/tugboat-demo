#!/bin/bash

cat << 'EOF'
                       .-`
                     -hMMs
                    hMMMo`
                    yMMMd-     ..
                     .yMMo   -yNNs
                       ``  -yNMMh- .ymd+`
                          yNMMh:`  :NMMMm+`
                          yhh:`     .sMMMMm.
                                    -hMMMMm.      ````
                                   -NMMMNs.      -::::----...`
                                   .hdho.        ---:::::::::::--.``
                                     `              ``````..--::::::-.`
                          ``      `..........                 ``.--::::-.`
                        `-::-`    `:::::::::-`                     `.-::::-`
                      .-::::.      .::::::::                          `.::::-.
                    .-:::-``       .::::::::                            `.-:::-.
                  `-:::-.          .::::::::                               .-:::-`
                 .::::.            .::::::::                                 .::::.
                -:::-`             .::::::::                                  `-:::.
               -:::-               .::::::::...........................`        -:::-
              -:::.                .::::::::::::::::::::::::::::::::::::`        .:::-
             -:::.                 .::::::::/++++++++++++++++++++++:::.`          .:::-
            .:::-                  .::::::::/++++////+++++////+++++:::.            -:::.
           `:::-                   .::::::::/+++/:::::+++::::::::--:::.             ::::
           .:::.                   .::::::::-----:::::`` -:::::`  `:::.             .:::.
           :::-                    .::::::::.    `..`     `..`  `.-:::-.```.....`    -:::
          `:::.                    .::::::::.       ````....----:::::::::::::::::-   .:::`
          .:::.                  `.::::::::::---::::::::::::::::::::/::::::-..-:::   .:::.
          .:::`    `...------:::::::::::::::::::::----....```-::::/++++:::::  .:::   `:::.
          .:::    -::::::::::::-::::::++++:::::`           ``:::::/+++/:::::  .:::    :::.
          .:::`   :::-..````    -::::/++++::::::-........--:::::::::::::::::---:::   `:::.
          `:::.   -:::..``````..:::::::/::::::::::::::::::::--+/::::::::://:::::::   .:::`
          `:::-   .:::::::::::::::/:::::::::///``....-...``   ./++//////++-``-:::.   -:::`
           -:::.``.::::-------..``/++//////++:`                 .::////:.`  `::::.``.:::-
           `:::::::::::-           .-/////:-`                               -:::::::::::`
            `.......-:::-` `````....-------------....````````            ``.:::-.......`
                     .::::-::::::::::::::::::::::::::::::::::------------:::::.
                      `-:::----...`````````````````....---------::::::-------.
                        ```` `````....------------....``````````````````````
                          ---:::::::::::::::::::::::::::::::::--------::::::`
                         `::::---.......````````........----::::::::::::----`
                          ```
            ````````````````  ````   ``````   ````````     ``````    ```````  ```````````
            .::::::::::..:::  .::: `-:::::::. .:::::::-. `-:::::::` .:::::::-`:::::::::::`
            -::::::::::-.:::  .::: -:::/:::::`.::::::::: -:::/::::: :::::/:::./::::::::::`
                -:::    .:::  .::: -::- `://: .:::``:::: -::-  -:::`:::- `:::.   .:::`
                .:::    .:::  .::: -::-.:::::`.::::::::: -::-  -:::`::::--:::.   .:::`
                .:::    .:::` -::: -:::.-::::`.:::::/:::.-::-  -:::`:::::::::.   .:::`
                .:::    -::::::::/ :::::::::: .:::--::::.:::::::::: ::::-::::.   .:::`
                -///     :///////.  ://////:` -////////:  ://////:` ///-  ///-   .///`
                           ````       ````                  ````
EOF

## Upgrade Drush
cd /usr/local/src/drush
git pull
git checkout 8.0.5
composer install

## Upgrade settings.php
cd /var/lib/tugboat/docroot/sites/default
cp default.settings.php settings.php

cat << EOF >> settings.php
if (file_exists(__DIR__ . '/settings.local.php')) {
  include __DIR__ . '/settings.local.php';
}
EOF

## Download & extract files
apt-get update
apt-get -y install unzip
rm -rf files
curl -L "https://www.dropbox.com/s/0wx8b6ef0l9eiuu/files.zip?dl=1&pv=1" > files.zip
unzip files.zip

## Download & import database
curl -L "https://www.dropbox.com/s/cqfyu0nsk2vtfff/tugboat-demo.sql?dl=1&pv=1" > ~/tugboat-demo.sql
mysql -h mysql -u tugboat -ptugboat -e 'drop database tugboat; create database tugboat;'
cat ~/tugboat-demo.sql | mysql -h mysql -u tugboat -ptugboat tugboat

## Import config
cd /var/lib/tugboat/docroot
drush -y config-import