<h2>Description:</h2>
// TODO: add a description
<h2>Calibre and recipes:</h2>
<p>You can read more about calibre and recipes here http://manual.calibre-ebook.com/news.html#tips-for-developing-new-recipes</p>
<p>And you can google around for recipes, or create your own, or look here https://github.com/kovidgoyal/calibre 
under recipes/ to find recipes created by community and by https://github.com/kovidgoyal and maintained by Kovid</p>
<p>You should use ebook-convert ver. >= 0.8.51</p>
<h2>How to use this scripts:</h2>
<h3>Conversion script</h3>
<p>First and foremost, look at it, add your feeds, postfix names, and set time how often you want your feeds checked.
I didn't made it to work with Kindle collections as this seems overly complicated to me.</p>
<p>And I create separate cron job for every feed because this seems the most flexible way.
After you looked at and modified the script, run it once. It will create cronjobs for converting your feeds into books.
Jobs are distinguished by postfix names, if you change something but not the name, rerun the script and it will change your settings.
</p>
