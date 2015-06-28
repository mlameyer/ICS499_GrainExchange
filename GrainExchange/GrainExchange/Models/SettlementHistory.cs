using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace GrainExchange.Models
{
    public class SettlementHistory
    {
        //Can we normalize this? Are there going to be more or less than 2 products per settlement history? 
        // We could pass a list of Product objects, which contain their own settle and flux
        public int settlementHistoryId { get; set; }
        public int portfolioId { get; set; }
        public string product { get; set; }
        public float productSettle { get; set; }
        public string product2 { get; set; }
        public float product2Settle { get; set; }
        public float productFlux { get; set; }
        public float product2Flux { get; set; }
        public float spreadFlux { get; set; }
        public float fluxExtension { get; set; }
        public int marginRequirement { get; set; }
        public float marginCoverage { get; set; }
        public DateTime settlementDate { get; set; }
        public string productOI { get; set; }
        public string product2OI { get; set; }
        public int maxOI { get; set; }
        public float marginExt { get; set; }
        public float fluxExt { get; set; }
        public float coverageExt { get; set; }
    }
}