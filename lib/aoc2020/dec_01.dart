/// --- Day 1: Report Repair ---
/// After saving Christmas five years in a row, you've decided to take a
/// vacation at a nice resort on a tropical island. Surely, Christmas will go
/// on without you.
///
/// The tropical island has its own currency and is entirely cash-only. The gold
/// coins used there have a little picture of a starfish; the locals just call
/// them stars. None of the currency exchanges seem to have heard of them, but
/// somehow, you'll need to find fifty of these coins by the time you arrive so
/// you can pay the deposit on your room.
///
/// To save your vacation, you need to get all fifty stars by December 25th.
///
/// Collect stars by solving puzzles. Two puzzles will be made available on each
/// day in the Advent calendar; the second puzzle is unlocked when you complete
/// the first. Each puzzle grants one star. Good luck!
///
/// Before you leave, the Elves in accounting just need you to fix your expense
/// report (your puzzle input); apparently, something isn't quite adding up.
///
/// Specifically, they need you to find the two entries that sum to 2020 and
/// then multiply those two numbers together.
///
/// For example, suppose your expense report contained the following:
///
/// 1721
/// 979
/// 366
/// 299
/// 675
/// 1456
/// In this list, the two entries that sum to 2020 are 1721 and 299. Multiplying
/// them together produces 1721 * 299 = 514579, so the correct answer is 514579.
///
/// Of course, your expense report is much larger. Find the two entries that sum
/// to 2020; what do you get if you multiply them together?
///
/// Your puzzle answer was 719796.
///
/// --- Part Two ---
/// The Elves in accounting are thankful for your help; one of them even offers
/// you a starfish coin they had left over from a past vacation. They offer you
/// a second one if you can find three numbers in your expense report that meet
/// the same criteria.
///
/// Using the above example again, the three entries that sum to 2020 are 979,
/// 366, and 675. Multiplying them together produces the answer, 241861950.
///
/// In your expense report, what is the product of the three entries that sum to
/// 2020?

const values = [
  96,
  277,
  372,
  384,
  462,
  489,
  780,
  804,
  813,
  1203,
  1223,
  1235,
  1237,
  1238,
  1241,
  1253,
  1256,
  1261,
  1270,
  1273,
  1274,
  1283,
  1288,
  1294,
  1297,
  1301,
  1303,
  1312,
  1313,
  1321,
  1323,
  1326,
  1327,
  1338,
  1351,
  1353,
  1359,
  1365,
  1366,
  1367,
  1368,
  1381,
  1388,
  1391,
  1395,
  1401,
  1404,
  1405,
  1416,
  1417,
  1420,
  1423,
  1424,
  1428,
  1429,
  1445,
  1456,
  1459,
  1464,
  1465,
  1468,
  1475,
  1477,
  1482,
  1491,
  1495,
  1498,
  1502,
  1506,
  1511,
  1512,
  1522,
  1524,
  1538,
  1539,
  1557,
  1558,
  1561,
  1562,
  1573,
  1575,
  1578,
  1580,
  1586,
  1600,
  1604,
  1611,
  1613,
  1616,
  1619,
  1623,
  1626,
  1631,
  1642,
  1646,
  1649,
  1651,
  1657,
  1659,
  1673,
  1678,
  1685,
  1686,
  1689,
  1690,
  1696,
  1702,
  1706,
  1707,
  1713,
  1714,
  1717,
  1724,
  1731,
  1733,
  1734,
  1735,
  1736,
  1738,
  1742,
  1746,
  1757,
  1759,
  1760,
  1763,
  1769,
  1770,
  1772,
  1773,
  1775,
  1778,
  1779,
  1792,
  1794,
  1801,
  1802,
  1804,
  1806,
  1807,
  1818,
  1821,
  1834,
  1836,
  1837,
  1844,
  1847,
  1848,
  1849,
  1850,
  1851,
  1859,
  1860,
  1861,
  1863,
  1872,
  1880,
  1884,
  1885,
  1889,
  1890,
  1893,
  1896,
  1900,
  1901,
  1903,
  1908,
  1911,
  1919,
  1929,
  1933,
  1934,
  1935,
  1936,
  1939,
  1940,
  1941,
  1943,
  1945,
  1953,
  1955,
  1956,
  1957,
  1962,
  1964,
  1968,
  1973,
  1982,
  1984,
  1989,
  1991,
  1996,
  1997,
  1998,
  1999,
  2000,
  2002,
  2003,
  2006,
  2007,
  2010,
];

void main() {
  // Part 1
  for (final a in values) {
    for (final b in values) {
      if (a + b == 2020) {
        assert(a * b == 719796);
        break;
      }
    }
  }

  // Part 2
  for (final a in values) {
    for (final b in values) {
      for (final c in values) {
        if (a + b + c == 2020) {
          assert(a * b * c == 144554112);
          break;
        }
      }
    }
  }
}
