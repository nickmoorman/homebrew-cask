### Description of issue

Looks like DisplayLink changed their download method again...  Attempting to install DisplayLink via Homebrew fails with a 404 on the download URL (see output below).  I went to initiate a manual download and inspect the network calls, and it looks like some Javascript on their page hits an intermediate route that generates a [signed AWS S3 URL](http://docs.aws.amazon.com/AmazonS3/latest/dev/RESTAuthentication.html#RESTAuthenticationQueryStringAuth) to the download file, which is finally called to perform the actual download.  Looks like it's fairly straightforward to put together a curl request to perform the download (see bottom of this issue for a sample).

### Output of `brew cask install --verbose Caskroom/cask/displaylink`

```
==> Caveats
Installing this Cask means you have AGREED to the DisplayLink
Software License Agreement at

  http://www.displaylink.com/support/sla.php?fileid=102

==> Downloading http://www.displaylink.com/downloads/file.php
/usr/bin/curl -fLA Homebrew-cask v0.51+ (Ruby 2.0.0-481) http://www.displaylink.com/downloads/file.php -C 0 -o /Library/Caches/Homebrew/displaylink-2.4.php.incomplete -d file=DisplayLink_OSX_2.4.dmg -d folder=publicsoftware -d id=420
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0curl: (22) The requested URL returned error: 404 Not Found
Error: Download failed on Cask 'displaylink' with message: Download failed: http://www.displaylink.com/downloads/file.php
Error: Kernel.exit
```

_(skipping output of `brew doctor` and `brew cask doctor` since they aren't relevant for this issue)_

### Solution

```
$ curl -vL -d fileId=117 -d accept_submit=Accept http://www.displaylink.com/downloads/file?id=117 -o displaylink.dmg
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0*   Trying 54.154.231.19...
* Connected to www.displaylink.com (54.154.231.19) port 80 (#0)
> POST /downloads/file?id=117 HTTP/1.1
> Host: www.displaylink.com
> User-Agent: curl/7.43.0
> Accept: */*
> Content-Length: 31
> Content-Type: application/x-www-form-urlencoded
> 
} [31 bytes data]
* upload completely sent off: 31 out of 31 bytes
< HTTP/1.1 303 See Other
< Cache-Control: no-store, no-cache, must-revalidate, post-check=0, pre-check=0
< Content-Type: text/html; charset=utf-8
< Date: Thu, 14 Apr 2016 17:44:09 GMT
< Expires: Thu, 19 Nov 1981 08:52:00 GMT
< Location: http://assets.displaylink.com/live/downloads/software/f117_DisplayLink_Mac_OS_X_2.5.dmg?AWSAccessKeyId=AKIAJHGQWPVXWHEDJUEA&Expires=1460656449&Signature=8G9YhfTYB4CBIdVm0l%2FNwFal41g%3D
< Pragma: no-cache
< Server: Apache/2.2.15 (Centos)
< Set-Cookie: DisplayLink=o24j18f8vli680h7kohts693v5; expires=Fri, 15-Apr-2016 03:44:09 GMT; path=/
< Vary: Accept-Encoding
< X-Powered-By: PHP/5.3.3
< Content-Length: 0
< Connection: keep-alive
< 
100    31    0     0  100    31      0     75 --:--:-- --:--:-- --:--:--    75
* Connection #0 to host www.displaylink.com left intact
* Issue another request to this URL: 'http://assets.displaylink.com/live/downloads/software/f117_DisplayLink_Mac_OS_X_2.5.dmg?AWSAccessKeyId=AKIAJHGQWPVXWHEDJUEA&Expires=1460656449&Signature=8G9YhfTYB4CBIdVm0l%2FNwFal41g%3D'
* Disables POST, goes with GET
*   Trying 54.231.134.43...
* Connected to assets.displaylink.com (54.231.134.43) port 80 (#1)
> GET /live/downloads/software/f117_DisplayLink_Mac_OS_X_2.5.dmg?AWSAccessKeyId=AKIAJHGQWPVXWHEDJUEA&Expires=1460656449&Signature=8G9YhfTYB4CBIdVm0l%2FNwFal41g%3D HTTP/1.1
> Host: assets.displaylink.com
> User-Agent: curl/7.43.0
> Accept: */*
> 
< HTTP/1.1 200 OK
< x-amz-id-2: sGxUUpmgKJpOB/K0lSdh74jfhxwMqYFv83nnFnEceCL991mqazwjTkCCjbjRP3e+wZWYxxHHKWo=
< x-amz-request-id: C811B7F45E9764DC
< Date: Thu, 14 Apr 2016 17:45:54 GMT
< Content-Disposition: attachment; filename=DisplayLink_Mac_OS_X_2.5.dmg
< Last-Modified: Thu, 31 Mar 2016 14:17:39 GMT
< ETag: "1c698eac935009d5484d0c5c9abb1f2b"
< Accept-Ranges: bytes
< Content-Type: application/octet-stream
< Content-Length: 4167184
< Server: AmazonS3
< 
{ [4296 bytes data]
100 4069k  100 4069k    0     0   314k      0  0:00:12  0:00:12 --:--:--  344k
* Connection #1 to host assets.displaylink.com left intact
```
