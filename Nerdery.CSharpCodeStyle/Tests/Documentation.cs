using System.Diagnostics.CodeAnalysis;
using System.Linq;

namespace Nerdery.CSharpCodeStyle.Tests
{
    /// <summary>
    /// This is a test for the things.
    /// </summary>
    internal class Documentation
    {
        /// <summary>
        /// This should have a comment
        /// </summary>
        public string PublicPropertyWithComment { get; set; }

        [SuppressMessage("Nerdery.CSharpCodeStyle.Rules.Documentation", "ND1006:PublicPropertiesShouldBeDocumented")]
        //This would throw an error if not suppressed
        public string PublicPropertyWithoutComment { get; set; }

        /// <summary>
        /// This should have a comment
        /// </summary>
        internal string InternalPropertyWithComment { get; set; }

        [SuppressMessage("Nerdery.CSharpCodeStyle.Rules.Documentation", "ND1003:InternalPropertiesShouldBeDocumented")]
        //This would throw an error if not suppressed
        internal string InternalPropertyWithoutComment { get; set; }

        protected string ProtectedPropertyWithoutComment { get; set; }

        private string PrivatePropertyWithoutComment { get; set; }

        /// <summary>
        /// This is a public Method1.
        /// </summary>
        public void Method1()
        {
        }

        /// <summary>
        /// Documenting the method things
        /// </summary>
        /// <param name="x">The x paramater</param>
        /// <param name="y">The y paramater</param>
        public void Method2(string x, int y)
        {
        }

        /// <summary>
        /// This is Method3.
        /// </summary>
        public void Method3()
        {
        }
    }
}