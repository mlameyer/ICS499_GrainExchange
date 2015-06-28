using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace GrainExchange.Models
{
    public class Spread
    {
        public int spreadId { get; set; }
        public int portfolioId {get;set;}
        public int direction { get; set; }
        public int contracts { get; set; }
        public Expiration expiration { get; set; }
        public string product { get; set; }
        public int leg { get; set; }
    }
}