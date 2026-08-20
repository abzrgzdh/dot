;;; plug-music.el  -*- lexical-binding: t; -*-


;;; Commentary:

;; Music related stuff in Emacs

;;; Code:


;; `mpc' a set of commands and key bindings to control mpd through mpc
(defconst rc/music-directory
  (expand-file-name "~/Music/m")
  "Root directory of the music collection.")

(defun rc/music--leaf-directories (root)
  "Return leaf directories below ROOT."
  (let (result)
    (dolist (dir (directory-files-recursively root "[^.]" t))
      (when (and (file-directory-p dir)
                 (not
                  (seq-some
                   #'file-directory-p
                   (directory-files dir t nil t))))
        (push dir result)))
    result))

(defun rc/music--albums ()
  "Return album directories under the music directories."
  (let (albums)
    (dolist (root '("m" "slsk"))
      (let ((root-dir (expand-file-name root rc/music-directory)))
        (when (file-directory-p root-dir)
          (setq albums
                (nconc albums
                       (rc/music--leaf-directories root-dir))))))
    (sort albums #'string-lessp)))

(defun rc/music--state ()
  "Return the current MPD playback state."
  (string-trim
   (shell-command-to-string "mpc status %state%")))

(defun rc/music--song ()
  "Return the current MPD song as TITLE - ARTIST."
  (string-trim
   (shell-command-to-string
    "mpc -f '%title% - %artist%' current")))

(defun rc/music--state-label (state)
  "Return a display label for MPD STATE."
  (pcase state
    ("playing" "Play")
    ("paused"  "Pause")
    ("stopped" "Stop")
    (_         "Unknown")))

(defun rc/music--report-current ()
  "Report MPD playback state and current song."
  (let ((state (rc/music--state))
        (song (rc/music--song)))
    (message "%s: %s"
             (rc/music--state-label state)
             song)))

(defun rc/music-play-album ()
  "Select an album and play it."
  (interactive)
  (let* ((albums (rc/music--albums))
         (display-albums
          (mapcar (lambda (dir)
                    (file-relative-name dir rc/music-directory))
                  albums))
         (completion-styles '(flex basic))
         (selected
          (completing-read
           "Album: "
           display-albums
           nil
           t)))
    (when selected
      (call-process "mpc" nil nil nil "clear")
      (call-process "mpc" nil nil nil "add" selected)
      (call-process "mpc" nil nil nil "play")
      (rc/music--report-current))))

(defun rc/music-toggle-play-pause ()
  "Toggle MPD playback and report the current song."
  (interactive)
  (call-process "mpc" nil nil nil "toggle")
  (rc/music--report-current))

(defun rc/music-play-next ()
  "Play the next song and report its name."
  (interactive)
  (call-process "mpc" nil nil nil "next")
  (rc/music--report-current))

(defun rc/music-play-previous ()
  "Play the previous song and report its name."
  (interactive)
  (call-process "mpc" nil nil nil "prev")
  (rc/music--report-current))



(global-set-key (kbd "C-c m a") #'rc/music-play-album)
(global-set-key (kbd "C-c m p") #'rc/music-toggle-play-pause)
(global-set-key (kbd "C-c m f") #'rc/music-play-next)
(global-set-key (kbd "C-c m b") #'rc/music-play-previous)



(provide 'plug-music)
;;; plug-music.el ends here.
