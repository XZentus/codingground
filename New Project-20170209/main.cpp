#include <vector>
#include <string>
#include <iostream>
#include <ios>
#include <limits>

using namespace std;

typedef pair < int, int >   pos;
typedef vector < pos >      coords;
typedef int					INT;

const int board_x   = 6;
const int board_y   = 6;

const int pattern_x = 3;
const int pattern_y = 3;

const string pattern_raw = "xxx" "\n"
                           " x " "\n"
                           "xxx";

class Coord {
	coords pattern_coords;
	int pattern_x;
	int pattern_y;
public:
	Coord ( const string & pattern ): pattern_x(0),
	                                  pattern_y(0) {
		int x = 0, y = 0;
		for ( const auto & c: pattern ) {
			if ( c == 'x' ) {
				pattern_coords.emplace_back ( x, y );
				pattern_x = max ( x, pattern_x );
				pattern_y = max ( y, pattern_y );
			}
			if ( c == '\n' ) {
				x = 0;
				y += 1;
			}
			else {
				x += 1;
			}
		}
	};
	
	auto cbegin() {
		return pattern_coords.cbegin();
	};
	
	auto cend() {
		return pattern_coords.cend();
	}
	auto get_size_x() {
		return pattern_x;
	}
	auto get_size_y() {
		return pattern_y;
	}

	Coord () = delete;
	~Coord() {
		pattern_coords.clear();
	}
};

int main(){
    ios::sync_with_stdio(false);
    
    Coord pattern_coords ( pattern_raw );
    
    vector < vector < INT > > board ( board_y );
    for ( int y = 0; y < board_y; ++y ) {
        for ( int x = 0; x < board_x; ++x ) {
            INT t; cin >> t;
            board[y].push_back ( t );
        }
    }
    
	INT max_sum = numeric_limits < INT > :: min();
	for ( int x = 0, lim_x = board_x - pattern_coords.get_size_x();
	          x < lim_x;
		      x += 1) {
		for ( int y = 0, lim_y = board_y - pattern_coords.get_size_y();
		          y < lim_y;
				  y += 1) {
            INT t_sum = 0;
			for ( auto beg = pattern_coords.cbegin(), end = pattern_coords.cend();
			           beg != end;
					   ++beg) {
		        t_sum += board[beg->second + y][beg->first + x];
			}
            max_sum = max ( t_sum, max_sum );
		}
	}
	
	cout << max_sum << endl;
	
    return 0;
}
