module TermUtils 
    (
    termSize
    ) where

import Foreign.C.Error (throwErrno)
import Foreign.C.Types (CUShort, CInt (..))
import Foreign.Marshal.Alloc (alloca)
import Foreign.Ptr (Ptr)
import Foreign.Storable (peek)
import GHC.IO.FD (stdout, fdFD)
import GHC.IO.Handle.FD (handleToFd)

#include "term_utils.h"

foreign import ccall unsafe "term_utils.h term_sz"
    c_term_sz :: CInt -> Ptr CUShort -> Ptr CUShort -> IO CInt


termSize :: IO (Int, Int)
termSize =
    alloca (\rowp ->
        alloca (\colp -> do
            res <- c_term_sz (fdFD stdout) rowp colp
            if res == -1 then
                throwErrno "termSize"
            else do
                row <- peek rowp
                col <- peek colp
                return (fromIntegral row, fromIntegral col)))

