;;; Package --- Sumary:
;;; Emacs main config file
;;; Commentary:

;;; Code:

(defvar test-dir (buffer-file-name))

(defun pwd! ()
  "Get the current working dir as string."
  (cadr (split-string (pwd))))

(defun parent-directory (dir)
  "Return parent directory of DIR."
  (unless (equal "/" dir)
    (file-name-directory (directory-file-name dir))))

(defun run-command-in-parrent-dir (command)
  "Run COMMAND in the parrent dir."
  (cd (parent-directory
       (file-name-directory (buffer-file-name))))
  (async-shell-command command))

(defun get-recipe-root (path)
  "Find the project root for PATH."
  (cd path)
  (if (file-exists-p (concat (pwd!) ".kitchen.yml"))
      (pwd!)
    (get-project-root (parent-directory (pwd!)))))

(defun run-command-in-recipe-root (command)
  "Run COMMAND in the recipe root folder."
  (cd (get-project-root (file-name-directory (buffer-file-name))))
    (async-shell-command command))

(defun kitchen-converge ()
  "Run chef test kitchen converge."
  (interactive)
  (run-command-in-recipe-root "kitchen converge"))

(defun kitchen-test ()
  "Run chef test kitchen test."
  (interactive)
  (run-command-in-recipe-root "kitchen test"))

(defun kitchen-destroy ()
  "Run chef test kitchen destory."
  (interactive)
  (run-command-in-recipe-root "kitchen destroy"))

(defun kitchen-verify ()
  "Run chef test kitchen destory."
  (interactive)
  (run-command-in-recipe-root "kitchen verify"))

(defun knife-boostrap ()
  "Bootstrap a new node using chef."
  (interactive)
  (let
      ((ip (read-string "Node IP: "))
       (name (read-string "Node name: "))
       (role (let ((choices '("default"  "mid-server" "unifi-controller")))
	       (ido-completing-read "Role: " choices))))
    (async-shell-command
     (concat "knife bootstrap " ip
	     " --ssh-user deploy --sudo --node-name " name
	     " --run-list 'role[" role "]'"
	     " --json-attributes '{\"cloud\": {\"public_ip\": \"" ip "\"}}' "))))

(provide 'chef)
