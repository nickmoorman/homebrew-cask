cask 'displaylink' do
  if MacOS.release <= :leopard
    # TODO: Releases <= Leopard don't appear to be supported anymore?
    version '1.7'
    sha256 'b35dc49fe286aa858d7f6f44fd3f6703de83fae2316d20b05e637a1134ba2440'
  elsif MacOS.release <= :lion
    version '2.2'
    sha256 '5c9a97a476b5ff27811491eebb653a03c96f899562b67566c24100d8593b1daa'
    fileId = '121'
  else
    version '2.5'
    sha256 'ee83d195bc35049f3d736b80d325c3e8590eaa528b068331d527eb289a97f195'
    fileId = '117'
  end

  url "http://www.displaylink.com/downloads/file?id=#{fileId}",
      data:  {
               'fileId'     => fileId,
               'accept_submit' => 'Accept',
             },
      using: :post
  name 'DisplayLink USB Graphics Software'
  homepage 'http://www.displaylink.com'
  license :gratis

  pkg 'DisplayLink Software Installer.pkg'

  uninstall pkgutil:   [
                         'com.displaylink.displaylinkdriver',
                         'com.displaylink.displaylinkdriversigned',
                         'com.displaylink.displaylinkdriverunsigned',
                       ],
            # 'kextunload -b com.displaylink.driver.DisplayLinkDriver' causes kernel panic
            # :kext => [
            #            'com.displaylink.driver.DisplayLinkDriver',
            #            'com.displaylink.dlusbncm'
            #           ],
            launchctl: [
                         'com.displaylink.useragent-prelogin',
                         'com.displaylink.useragent',
                         'com.displaylink.displaylinkmanager',
                       ],
            quit:      'DisplayLinkUserAgent',
            delete:    [
                         '/Applications/DisplayLink',
                         '/Library/LaunchAgents/com.displaylink.useragent-prelogin.plist',
                         '/Library/LaunchAgents/com.displaylink.useragent.plist',
                         '/Library/LaunchDaemons/com.displaylink.displaylinkmanager.plist',
                       ]

  caveats <<-EOS.undent
    Installing this Cask means you have AGREED to the DisplayLink
    Software License Agreement at

      http://www.displaylink.com/downloads/file?id=#{fileId}
  EOS
end
