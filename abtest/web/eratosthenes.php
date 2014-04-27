<?php
function normal($max) {
    $primeLists = array();
    for ($i=2; $i<=$max; $i++) {
        $isPrime = true;
        for ($k=2; $k<$i; $k++) {
            // 割り切れた数が存在したらアウト
            if ($i % $k === 0) {
                $isPrime = false;
                break;
            }
        }
        if ($isPrime) {
            $primeLists[] = $i;
        }
    }
    return $primeLists;
}
print_r(normal(10000));
