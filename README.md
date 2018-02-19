# Semantics of Programming Languages @ [University of Geneva](http://www.unige.ch)

This repository contains important information about this course.
**Do not forget to [watch](https://github.com/cui-unige/semantique/subscription) it**
as it will allow us to send notifications for events,
such as new exercises, homework, slides or fixes.

## Important Information and Links

* [Page on Moodle](https://moodle.unige.ch/course/view.php?id=182)
* [Page on GitHub](https://github.com/cui-unige/semantique)
* Courses are Tuesday 10:00 - 12:00
* Exercises are Monday 16:00 - 18:00

## Environment

This course requires the following **mandatory** environment.
We have taken great care to make it as simple as possible.

* [Moodle](https://moodle.unige.ch)
  Check that you are registered in the "Sémantique" classroom;
  we will not use it afterwards.
* [GitHub](https://github.com): a source code hosting platform
  that we will for the exercises and homework.
  Create an account, and **do not forget** to fill your profile with your full name
  and your University email address.
  Ask GitHub for a [Student Pack](https://education.github.com/pack) to obtain
  free private repositories.
* [MacOS High Sierra](https://www.apple.com/macos/high-sierra/)
  or [Ubuntu 16.04 LTS 64bits](https://www.ubuntu.com/download/desktop),
  in a virtual machine, using for instance [VirtualBox](http://virtualbox.org),
  or directly with a dual boot.

You also have to:
* [Watch](https://github.com/cui-unige/semantique/subscription)
  the [course page](https://github.com/cui-unige/semantique)
  to get notifications about the course.
* [Create a **private** repository](https://help.github.com/articles/creating-a-new-repository/)
  named `semantique` (exactly).
* [Clone the course repository](https://help.github.com/articles/cloning-a-repository/)

  ```sh
  git clone https://github.com/cui-unige/semantique.git
  ```

* [Duplicate the course repository into your private one](https://help.github.com/articles/duplicating-a-repository/)

  ```sh
  cd semantique
  git push --mirror https://github.com/yourusername/semantique.git
  ```

* Update the repository information

  ```sh
  atom .git/config
  ```

  And replace `cui-unige` by your GitHub username.
* Set the upstream repository:

  ```sh
  git remote add upstream https://github.com/cui-unige/semantique.git
  ```

* [Add as collaborators](https://help.github.com/articles/inviting-collaborators-to-a-personal-repository/)
  the users: [`saucisson`](https://github.com/saucisson) (Alban Linard)
  and [`didierbuchs`](https://github.com/didierbuchs) (Didier Buchs).
* Run the following script to install dependencies:

  ```sh
    curl -s https://raw.githubusercontent.com/cui-unige/semantique/master/install | bash /dev/stdin
  ```

The environment you installed contains:
* [Git](https://git-scm.com/docs/gittutorial):
  the tool for source code management;
* [Swift](https://developer.apple.com/swift/):
  the programming language that we will use;
* [Atom](https://atom.io):
  the editor we will use.
  On the first launch, Atom asks to install some missing modules.
  **Do not forget to accept**, or your environment will be broken.

Make sure that your [repository is up-to-date](https://help.github.com/articles/syncing-a-fork/)
by running frequently:

```sh
  git fetch upstream
  git merge upstream/master
```

## Rules

* You must do your homework in your private fork of the course repository.
* You must fill your full name in your GitHub profile.
* If for any reason you have trouble with the deadline,
  contact your teacher as soon as possible.
* We must have access to your source code, that must be private.
* You code must compile without any error or warning.

## Homework

* All homeworks are located in the `homework/` directory.
* Use the command `swift test` to test your work.
