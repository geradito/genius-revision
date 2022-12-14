<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Subject extends Model
{
    use HasFactory;

    public function questions()
    {
        return $this->hasMany('App\Models\Question');
    }
    
    public function grade()
    {
        return $this->belongsTo('App\Models\Grade');
    }
}
