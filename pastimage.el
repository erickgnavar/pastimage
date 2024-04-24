;;; pastimage.el --- Insert images link from clipboard -*- lexical-binding: t -*-

;; Copyright © 2024 Erick Navarro
;; Author: Erick Navarro <erick@navarro.io>
;; URL: https://github.com/erickgnavar/cloak-mode
;; Version: 0.1.0
;; SPDX-License-Identifier: GPL-3.0-or-later
;; Package-Requires: ((emacs "25.1") (project "0.1")

;;; Commentary:
;;; Code:

(require 'project)

(defcustom pastimage-store-function 'pastimage-default-store-function
  "Function to be called to generate image directory."
  :group 'pastimage
  :type 'function)

(defun pastimage--insert-markup (doc-mode image-path)
  "Insert markup using received `DOC-MODE' and `IMAGE-PATH'."
  (cond ((string-equal doc-mode "markdown-mode")
         (insert (format "![image](%s)" image-path)))
        ((string-equal doc-mode "org-mode")
         (insert (format "[[file:%s]]" image-path)))
        ((string-equal doc-mode "rst-mode")
         (insert (format ".. image:: %s" image-path)))
        (t (message "Invalid doc-mode %s" doc-mode))))

(defun pastimage--store-image (image-path)
  "Store image in disk using the received `IMAGE-PATH'."
  (cond ((string-equal system-type "darwin")
         (unless (executable-find "pngpaste")
           (user-error "Please install pngpaste")))
        ((string-equal system-type "gnu/linux")
         (user-error "Not supported yet")))
  (shell-command (format "pngpaste %s" image-path)))

(defun pastimage-default-store-function ()
  "Return a default directory using current project directory."
  (let* ((project-dir (expand-file-name (project-root (project-current))))
         (images-dirname "images")
         (images-dir (concat (file-name-as-directory project-dir) (file-name-as-directory images-dirname))))
    (unless (file-exists-p images-dir)
      (mkdir images-dir t))
    images-dir))

(defun pastimage-insert-from-clipboard ()
  "Insert image markup from image in clipboard."
  (interactive)
  (let* ((image-dir (apply pastimage-store-function '()))
         (image-name (read-string "Enter image name: "))
         (image-path (expand-file-name image-name image-dir)))
    (pastimage--store-image image-path)
    (pastimage--insert-markup major-mode image-path)))

(provide 'pastimage)
;;; pastimage.el ends here
