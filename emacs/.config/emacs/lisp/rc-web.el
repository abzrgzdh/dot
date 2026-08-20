;;; rc-web.el  -*- lexical-binding: t; -*-

;;; Commentary:

;; Browsing internet and interaction between Emacs and the default browser

;;; Code:


;;; ----------------------------------------------------------------------
;; `atomic-chrome' allows editing text areas in browsers with the help of
;; GhostText extension (or AtomicChrome extension)
(use-package atomic-chrome
  :ensure t
  ;; commented if as otherwise it would not work with emacs client.
  ;; :if window-system
  :ensure t
  :demand t

  :custom
  (atomic-chrome-extension-type-list '(ghost-text))
  (atomic-chrome-default-major-mode 'markdown-mode)
  (atomic-chrome-server-ghost-text-port 4001)
  (atomic-chrome-buffer-open-style 'frame)
  (atomic-chrome-buffer-frame-width 100)
  (atomic-chrome-buffer-frame-height 30)

  :config
  (atomic-chrome-start-server)

  (when (fboundp 'gfm-mode)
    (setq atomic-chrome-url-major-mode-alist
          '(("overleaf\\.com"    . latex-mode)
            ("mail\\.google\\.com" . text-mode)
            ("github\\.com"      . gfm-mode)
            ("gitlab\\.com"      . gfm-mode)))))



;; `webjump' start searching right from Emacs and land on your desired website.
(use-package webjump
  :ensure nil
  :bind ("C-c /" . webjump)
  :init (setq webjump-sites
              '(;; Emacs
                ("Emacs Home Page" .
                 "www.gnu.org/software/emacs/emacs.html")
                ("Xah Emacs Site" . "ergoemacs.org/index.html")
                ("(or emacs irrelevant)" . "oremacs.com")
                ("Mastering Emacs" .
                 "https://www.masteringemacs.org/")

                ;; Search engines.
                ("DuckDuckGo" .
                 [simple-query "duckduckgo.com"
                               "duckduckgo.com/?q=" ""])
                ("Google" .
                 [simple-query "www.google.com"
                               "www.google.com/search?q=" ""])

                ("YouTube" .
                 [simple-query "www.youtube.com"
                               "https://www.youtube.com/results?search_query=" ""])

                ("Wikipedia" .
                 [simple-query "wikipedia.org" "wikipedia.org/wiki/" ""]))))



;; ;; `erc' IRC
;; (use-package erc
;;   :demand nil
;;   :ensure nil
;;   :commands erc
;;   :defines erc-interpret-mirc-color erc-autojoin-channels-alist
;;   :init (setq erc-interpret-mirc-color t
;;               erc-lurker-hide-list '("JOIN" "PART" "QUIT")
;;               erc-autojoin-channels-alist '(("freenode.net" "#emacs"))))



;; `elfeed': provide rss feed-reader capabilities to Emacs.
(use-package elfeed
  :hook (elfeed-search-mode . buffer-wrap-mode)
  :bind (("C-c e" . elfeed))
  :init
  (setq elfeed-db-directory (concat user-emacs-directory ".elfeed")

        ;; Use unique buffers for each elfeed article
        elfeed-show-entry-switch #'pop-to-buffer
        elfeed-show-unique-buffers t

        elfeed-show-entry-delete #'delete-window
        elfeed-feeds '(("https://abzrg.github.io/rss.xml" me)

                       ;; Emacs
                       ("https://planet.emacslife.com/atom.xml" planet emacslife)
                       ("http://www.masteringemacs.org/feed/" mastering)
                       ("https://oremacs.com/atom.xml" oremacs)
                       ("https://pinecast.com/feed/emacscast" emacscast)
                       ("https://emacstil.com/feed.xml" Emacs TIL)

                       ;; News
                       ("https://news.ycombinator.com/rss" hackernews news)
                       ("https://www.reddit.com/r/commandline/.rss?limit=100" reddit content)

                       ;; C/C++
                       ("https://nullprogram.com/feed/" c)
                       ("https://www.sandordargo.com/feed.xml" c++)

                       ;; Python
                       ("https://til.simonwillison.net/tils/feed.atom" python)

                       ;; Prot
                       ("https://protesilaos.com/codelog.xml" emacs linux)
                       ("https://protesilaos.com/interpretations.xml" art philosophy)

                       ;; CFD
                       ("https://old.reddit.com/r/CFD/.rss?limit=100" reddit cfd)

                       ;; Other
                       ("https://acoup.blog/feed/" blog)
                       ("https://lukesmith.xyz/index.xml" blog)

                       ("https://www.joshwcomeau.com/rss.xml" blog web)
                       ("https://safjan.com/feeds/all.rss.xml" blog)
                       ("https://research.swtch.com/feed.atom" blog )
                       ("https://flaviocopes.com/rss.xml" blog)
                       ("https://protesilaos.com/master.xml" blog emacs philosophy)
                       ("https://zarif98sjs.github.io/index.xml" blog)
                       ("https://endler.dev/rss.xml" blog)
                       ("https://codelearn.me/feed.xml" blog)
                       ("https://tony-zorman.com/atom.xml" blog)

                       ;; from nullprogram
                       ("https://nullprogram.com/feed/" blog dev myself)
                       ("https://old.reddit.com/r/C_Programming/.rss?limit=100" subreddit)
                       ("https://xkcd.com/atom.xml" comic)

                       ;; ("https://blog.cryptographyengineering.com/feed/" blog)
                       ;; ("https://astralcodexten.substack.com/feed/" blog philosophy)
                       ;; ("https://betonit.substack.com/feed/" blog economics)
                       ;; ("https://simblob.blogspot.com/feeds/posts/default" blog dev)
                       ;; ("https://utcc.utoronto.ca/~cks/space/blog/?atom" blog dev)
                       ;; ("https://lemire.me/blog/feed/" dev blog)
                       ;; ("https://danluu.com/atom.xml" dev blog)
                       ;; ("https://www.debian.org/security/dsa" debian list security important)
                       ;; ("https://www.debian.org/News/news" debian list)
                       ;; ("https://www.filfre.net/feed/" blog history essay)
                       ;; ("https://danwang.co/feed/" blog philosophy)
                       ;; ("https://eli.thegreenplace.net/feeds/all.atom.xml" blog dev)
                       ;; ("https://floooh.github.io/feed.xml" blog dev)
                       ;; ("https://peter0x44.github.io/index.xml" blog dev)
                       ;; ("https://www.exocomics.com/feed" comic)
                       ;; ("https://fabiensanglard.net/rss.xml" blog dev)
                       ;; ("https://gcc.gnu.org/git/?p=gcc-wwwdocs.git;a=atom;f=htdocs/releases.html" dev release)
                       ;; ("https://github.com/rmyorston/busybox-w32/releases.atom" release product)
                       ;; ("https://backend.deviantart.com/rss.xml?q=by%3AGydw1n" image)
                       ;; ("https://photo.nullprogram.com/feed/" photo myself)
                       ;; ("https://loadingartist.com/feed/" comic)
                       ;; ("https://marc-b-reynolds.github.io/feed.xml" dev blog math)
                       ;; ("http://www.mazelog.com/rss" math puzzle)
                       ;; ("https://sourceforge.net/projects/mingw-w64/rss?path=/mingw-w64/mingw-w64-release" dev release)
                       ;; ("https://www.mrmoneymustache.com/feed/" blog philosophy)
                       ;; ("https://nrk.neocities.org/rss.xml" blog dev)
                       ;; ("https://blogs.msdn.microsoft.com/oldnewthing/feed" blog dev)
                       ;; ("https://www.overcomingbias.com/feed" blog philosophy)
                       ;; ("http://feeds.feedburner.com/PoorlyDrawnLines" comic)
                       ;; ("https://maskray.me/blog/atom.xml" blog dev)
                       ;; ("https://www.npr.org/rss/podcast.php?id=510289" podcast audio economics)
                       ;; ("https://possiblywrong.wordpress.com/feed/" blog math puzzle)
                       ;; ("http://feeds.wnyc.org/radiolab" audio)
                       ;; ("https://www.smbc-comics.com/comic/rss" comic)
                       ;; ("https://blog.plover.com/index.atom" blog dev)
                       ;; ("http://hnapp.com/rss?q=host:nullprogram.com" hackernews myself)
                       ;; ("https://old.reddit.com/domain/nullprogram.com.rss" reddit myself)

                       ("https://www.youtube.com/feeds/videos.xml?channel_id=andreas_fertig" youtube c++)
                       ("https://www.youtube.com/feeds/videos.xml?channel_id=TsodingDaily" youtube)
                       ("https://www.youtube.com/feeds/videos.xml?channel_id=iran_sport" youtube)
                       ("https://www.youtube.com/feeds/videos.xml?channel_id=JadiMirmirani" youtube)
                       ("https://www.youtube.com/feeds/videos.xml?channel_id=gitbutlerapp" youtube)
                       ("https://www.youtube.com/feeds/videos.xml?channel_id=yousuckatprogramming" youtube)
                       ("https://www.youtube.com/feeds/videos.xml?channel_id=anthonywritescode" youtube)
                       ("https://www.youtube.com/feeds/videos.xml?channel_id=Computerphile" youtube)
                       ("https://www.youtube.com/feeds/videos.xml?channel_id=numberphile" youtube)
                       ("https://www.youtube.com/feeds/videos.xml?channel_id=protesilaos" youtube)
                       ("https://www.youtube.com/feeds/videos.xml?channel_id=MollyRocket" youtube) ; Casey Muratori
                       ("https://www.youtube.com/feeds/videos.xml?channel_id=fluidmechanics101" youtube cfd)
                       ("https://www.youtube.com/feeds/videos.xml?channel_id=TomScottGo" youtube)
                       ("https://www.youtube.com/feeds/videos.xml?channel_id=GregHurrell" youtube)
                       ("https://www.youtube.com/feeds/videos.xml?channel_id=CodeForYourself" youtube)

                       ("https://www.youtube.com/feeds/videos.xml?channel_id=UULFHnyfMqiRRG1u-2MsSQLbXA" youtube) ; Veritasium
                       ;; ("https://www.youtube.com/feeds/videos.xml?channel_id=adric22" youtube) ; The 8-Bit Guy
                       ;; ("https://www.youtube.com/feeds/videos.xml?channel_id=craig1black" youtube)              ; Adrian's Digital Basement
                       ;; ("https://www.youtube.com/feeds/videos.xml?channel_id=UCbtwi4wK1YXd9AyV_4UcE6g" youtube) ; Adrian's Digital Basement ][
                       ;; ("https://www.youtube.com/feeds/videos.xml?channel_id=UCd8v3SbzGP9_wuSOr_xk_eA" youtube) ; Antique Furniture Restoration
                       ("https://www.youtube.com/feeds/videos.xml?channel_id=UCH_7doiCkWeq0v3ycWE5lDw" youtube) ; Any Austin
                       ("https://www.youtube.com/feeds/videos.xml?channel_id=UCbGGg1xyVana3IY4WInzgyg" youtube) ; Blow Fan
                       ;; ("https://www.youtube.com/feeds/videos.xml?channel_id=damo2986" youtube)
                       ;; ("https://www.youtube.com/feeds/videos.xml?channel_id=destinws2" youtube)
                       ;; ("https://www.youtube.com/feeds/videos.xml?channel_id=EEVblog" youtube)
                       ;; ("https://www.youtube.com/feeds/videos.xml?channel_id=eevblog2" youtube)
                       ;; ("https://www.youtube.com/feeds/videos.xml?channel_id=foodwishes" youtube)
                       ;; ("https://www.youtube.com/feeds/videos.xml?channel_id=UULFtWCNdtCS-SG2gKYaYhE7BA" youtube) ; Gaming Jay
                       ;; ("https://www.youtube.com/feeds/videos.xml?channel_id=UULFN9UPjA8I-uwvAy0-N9maOA" youtube) ; The Generalist Papers
                       ;; ("https://www.youtube.com/feeds/videos.xml?channel_id=UCuCkxoKLYO_EQ2GeFtbM_bw" youtube) ; Half as Interesting
                       ;; ("https://www.youtube.com/feeds/videos.xml?channel_id=UCm9K6rby98W8JigLoZOh6FQ" youtube) ; LockPickingLawyer
                       ;; ("https://www.youtube.com/feeds/videos.xml?channel_id=jastownsendandson" youtube)
                       ;; ("https://www.youtube.com/feeds/videos.xml?channel_id=MatthiasWandel" youtube)
                       ;; ("https://www.youtube.com/feeds/videos.xml?channel_id=UC3_AWXcf2K3l9ILVuQe-XwQ" youtube) ; Matthias random stuff
                       ;; ("https://www.youtube.com/feeds/videos.xml?channel_id=Nerdwriter1" youtube)
                       ;; ("https://www.youtube.com/feeds/videos.xml?channel_id=UCNyGbxoEo6CQvaRVEvItxkA" youtube) ; Pask Makes
                       ;; ("https://www.youtube.com/feeds/videos.xml?channel_id=UULFF1fG3gT44nGTPU2sVLoFWg" youtube) ; Patrick (H) Willems
                       ;; ("https://www.youtube.com/feeds/videos.xml?channel_id=Pixelmusement" youtube)
                       ;; ("https://www.youtube.com/feeds/videos.xml?channel_id=PlumpHelmetPunk" youtube)
                       ;; ("https://www.youtube.com/feeds/videos.xml?channel_id=ProZD" youtube)
                       ;; ("https://www.youtube.com/feeds/videos.xml?channel_id=XboxAhoy" youtube)
                       ;; ("https://www.youtube.com/feeds/videos.xml?channel_id=RedLetterMedia" youtube)
                       ;; ("https://www.youtube.com/feeds/videos.xml?channel_id=Cercopithecan" youtube) ; Sebastian Lague
                       ;; ("https://www.youtube.com/feeds/videos.xml?channel_id=UC1_uAIS3r8Vu6JjXWvastJg" youtube) ; Mathologer
                       ;; ("https://www.youtube.com/feeds/videos.xml?channel_id=standupmaths" youtube)
                       ;; ("https://www.youtube.com/feeds/videos.xml?channel_id=UCg-_lYeV8hBnDSay7nmphUA" youtube) ; Tally Ho
                       ;; ("https://www.youtube.com/feeds/videos.xml?channel_id=UCy0tKL1T7wFoYcxCe0xjN6Q" youtube) ; Technology Connections
                       ;; ("https://www.youtube.com/feeds/videos.xml?channel_id=UClRwC5Vc8HrB6vGx6Ti-lhA" youtube) ; Technology Connextras
                       ;; ("https://www.youtube.com/feeds/videos.xml?channel_id=UCqrrxZeeFSNCjGmD-33SKMw" youtube) ; u m a m i
                       ("https://www.youtube.com/feeds/videos.xml?channel_id=handmadeheroarchive" youtube dev)
                       ;; ("https://www.youtube.com/feeds/videos.xml?channel_id=UCwRqWnW5ZkVaP_lZF7caZ-g" youtube) ; Retro Game Mechanics Explained
                       ;; ("https://www.youtube.com/feeds/videos.xml?channel_id=phreakindee" youtube)
                       ;; ("https://www.youtube.com/feeds/videos.xml?channel_id=UCCj_mkYyeGIb9MPSdb74ykA" youtube) ; GET OFF MY LAWN
                       ;; ("https://www.youtube.com/feeds/videos.xml?channel_id=szyzyg" youtube)
                       ("https://www.youtube.com/feeds/videos.xml?channel_id=UCsXVk37bltHxD1rDPwtNM8Q" youtube) ; Kurzgesagt – In a Nutshell
                       ("https://www.youtube.com/feeds/videos.xml?channel_id=UCq8ZAAsI89IoJ-fn1gYpO3g" youtube) ; Kurzgesagt After Dark
                       ;; ("https://www.youtube.com/feeds/videos.xml?channel_id=UULFtKUW8LJK2Ev8hUy9ZG_PPA" youtube) ; Welker Farms
                       )))



;; `elfeed-goodies' some aditional niceties to elfeed.
(use-package elfeed-goodies
  :after elfeed)



;; `vpn/unvpn' interactive commands to connect to / disconnect from proxies
;;
;; This sets `url-proxy-services' so that Emacs's own HTTP/HTTPS
;; requests go through the proxy, and also updates environment
;; variables for child processes.
(use-package emacs
  :ensure nil
  :preface
  (defun rc/vtor ()
    "Enable Tor HTTP(S) proxy."
    (interactive)
    (let ((proxy "127.0.0.1:9080"))  ; note: no "http://" prefix for url-proxy-services
      (setq url-proxy-services
            '(("no_proxy" . "^\\(localhost\\|127\\.0\\.0\\.1\\)")
              ("http"   . "127.0.0.1:9080")
              ("https"  . "127.0.0.1:9080")))
      (message "Set HTTP proxy to use Tor (via HTTP), on port 9080")))

  (defun rc/unvpn ()
    "Disable HTTP(S) proxy."
    (interactive)
    (setq url-proxy-services nil)
    (message "Disable HTTP(S) proxies.")))



(provide 'rc-web)
;;; rc-web.el ends here.
