#Check content of file
get-content .\Books.xml

cls
#this is a small file ~4kb
(get-item .\Books.xml ).length /1kb

# Here's what most people do
measure-command { 1..100 | % { $a = gc .\Books.xml } }

# Here's what people should do...
measure-command { 1..100 | % { $a = gc -Raw .\Books.xml } }

cls
#here's why
$XmlContent = Get-Content .\Books.xml
$XmlContent.GetType().ToString()

#compare it to
$xmlRawContent = Get-Content -Raw .\Books.xml
$xmlRawContent.GetType().ToString()

cls
#Similarly 
measure-command { 1..100 | % { $a = [xml](gc .\Books.xml) } }

measure-command { 1..100 | % { $a = [xml](gc -raw .\Books.xml) } }

measure-command { 1..100 | % { $a = [xml]::new(); $a.Load('.\Books.xml') } }

# But is it linear?

1..10 | % {
    (measure-command { 1..(20*$_) | % { $a = [xml](gc .\Books.xml) } }).TotalMilliseconds/(10*$_)
}

