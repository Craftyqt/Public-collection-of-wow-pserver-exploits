using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Multiboxer
{
    public class Location
    {
        /* Location.cs
         * Helpful class used for storing 3-dimensional location data & calculations */

        public float X { get; set; }
        public float Y { get; set; }
        public float Z { get; set; }

        public Location()
        {
            X = 0f;
            Y = 0f;
            Z = 0f;
        }

        public Location(float x, float y, float z)
        {
            X = x;
            Y = y;
            Z = z;
        }

        public double CalcDistance(Location otherLoc)
        {
            // d = ( (x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2 )^0.5

            double x1 = X;
            double y1 = Y;
            double z1 = Z;

            double x2 = otherLoc.X;
            double y2 = otherLoc.Y;
            double z2 = otherLoc.Z;

            double dist = Math.Pow(Math.Pow(x2 - x1, 2) + Math.Pow(y2 - y1, 2) + Math.Pow(z2 - z1, 2), 0.5f);

            return dist;
        }

        public override string ToString()
        {
            return $"{X}, {Y}, {Z}";
        }
    }
}
