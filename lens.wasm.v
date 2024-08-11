fn JS.init( app &App )
fn JS.sqrt( r f64) f64

const width = i32(480)
const height = i32(270)


struct App{
mut:
    frame   [480*270]u8
    texture [480*270]u8
    ox i32
    oy i32
}

__global(
app = App{}
)

const radius=i32(50)
const radius2=f64(radius*radius)

pub fn (mut this App) draw () {
    ra2 := radius*radius
    m:= f64 ( 0.5 ) // magnification
    for x:=i32(0); x<width; x+=1 {
	mut xr:=x
	x_ox:=x-this.ox
        x2:=(x_ox)*(x_ox)
        for y:=i32(0); y<height; y+=1 {
	    mut yr:=y
	    y_oy:=y-this.oy
	    y2:=(y_oy)*(y_oy)
	    r2:= x2 + y2
            if r2 < ra2 {
		xf := f64 ( x_ox )
		yf := f64 ( y_oy )
		// Division model
		// Link: https://en.wikipedia.org/wiki/Distortion_(optics)
		k:= 1.0 - JS.sqrt(r2)/radius
		//k:= 1.0 - f64(r2)/radius2
		xr = this.ox + i32 ( m * xf/k )
                yr = this.oy + i32 ( m * yf/k )

		if xr<0 || xr>=width || yr<0 || yr>=height {
		    xr=x
		    yr=y
		}
	    }
	    this.frame[x+y*width] = this.texture[xr+yr*width]
	}
    }
}

pub fn (mut app App)keydown ( key &u8, code &u8 ) {}

pub fn (mut this App)mousedown ( x u32,y u32 ) {}
pub fn (mut this App)mouseup ( x u32, y u32 ) {}
pub fn (mut this App)mousemove ( x u32, y u32 ) {
	this.ox=i32(x)
	this.oy=i32(y)   
}

pub fn main ( ) {
    JS.init ( app )

    for y:=0; y < height; y+=1 {
        for x:=0; x < width; x+=1 {
	   app.texture[x+y*480] =
           /*if (x%50 < 25) == (y%50 < 25) {
               u8(1)
           } else {
	       u8(0)
           }*/
            u8((x/25+y/25)%4)
	}
    }
}
