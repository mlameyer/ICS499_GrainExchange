using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace GrainExchange.Models
{
    public class Settlement
    {
        public int portfolioId { get; set; }
        public int leg { get; set; }
        //Are we going to store more info about a product?  As in, does it need it's own class?
        public string product { get; set; }
        public float productSettle { get; set; }
        public DateTime settlementDate { get; set; }

    }
}