# romanian-holidays
Romanian holidays for GNU Emacs' Calendar


## Installation

TBD

## Usage

You can use `romanian-holidays' in several ways. Two examples follow.

To replace the built-in list of holidays with all the romanian ones:

    (setq calendar-holidays romanian-holidays-all-holidays)

To add the romanian legal days off as the user-defined holidays:

    (setq holiday-other-holidays romanian-holidays-legal)

You may also want to disable all (or some of) the pre-defined holidays:

    (setq holiday-general-holidays nil
          holiday-bahai-holidays nil
          holiday-hebrew-holidays nil
          holiday-christian-holidays nil
          holiday-islamic-holidays nil
          holiday-oriental-holidays nil)

## Contributing

If you find a problem, please report an
[issue](https://github.com/petrem/romanian-holidays/issues).

If you would like to contribute with changes, please report an issue and add a pull
request.

Some tests were written to check the `romanian-holidays--holiday-orthodox-easter-etc`
function. They can be run with:

    emacs -q -batch -l ert -l romanian-holidays-test.el -f ert-run-tests-batch-and-exit

## License

GPL-3.0-only License

Copyright (c) 2024 Petre Mierluțiu

This program is free software: you can redistribute it and/or modify it under the terms
of the GNU General Public License as published by the Free Software Foundation, either
version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this
program. If not, see <https://www.gnu.org/licenses/>.
