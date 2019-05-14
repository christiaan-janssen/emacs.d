;;; Package --- Sumary:
;;; Emacs main config file
;;; Commentary:

;;; Code:


(defun parent-directory (dir)
  "return parent directory of dir."
  (unless (equal "/" dir)
    (file-name-directory (directory-file-name dir))))

(defun run-command-in-parrent-dir (command)
  (cd (parent-directory
       (file-name-directory (buffer-file-name))))
  (async-shell-command command))

(defun kitchen-converge ()
  "Run chef test kitchen converge."
  (interactive)
  (run-command-in-parrent-dir "kitchen converge"))

(defun kitchen-test ()
  "Run chef test kitchen test."
  (interactive)
  (run-command-in-parrent-dir "kitchen test"))

(defun kitchen-destroy ()
  "Run chef test kitchen destory."
  (interactive)
  (run-command-in-parrent-dir "kitchen destroy"))

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
