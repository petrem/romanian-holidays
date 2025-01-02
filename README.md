# romanian-holidays
Romanian holidays for GNU Emacs' Calendar


## Installation & Usage

See the `Commentary` section in [romanian-holidays.el](romanian-holidays.el).

## Contributing

If you find a problem, please report an
[issue](https://github.com/petrem/romanian-holidays/issues).

If you would like to contribute with changes, please report an issue and add a pull
request.

Some tests were written to check the `romanian-holidays--holiday-orthodox-easter-etc`
function. They can be run with e.g.:

    emacs -q -batch -l ert -l test/romanian-holidays-orthodox-easter-test.el -f ert-run-tests-batch-and-exit

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
