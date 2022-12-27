<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Category;
use App\Models\Grade;
use App\Models\Subject;
use App\Models\LeaderBoard;

class CategoryController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        //
        $categories = Category::has('grades')->get();
        return $categories;
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        //
        $categories = Category::all();
        return view('category.create',["categories"=>$categories]);
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
             //Validation the Data
            $validatedData = $request->validate([
                'name' => ['required','max:20'],
            ],
            [
                'name.required' => 'Category name is required',
                'name.max' => 'Category name should not be greater than 20 characters.',
            ]);

        $category = new Category();
        $category->name = $request->name;
        $category->save();
        return redirect('categories/create');
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        //
    }

        /**
     * 
     *
     *  * @return \Illuminate\Http\Response
     */
    public function leaderboard ($id)
    {
        // 
        $leaderboards = Leaderboard::where('category_id', $id)->orderBy('points', 'desc')->get(['username','points','category_id']);    
        return $leaderboards;
    }
       /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function saveLeaderboard (Request $request)
    {
        //     
        $validatedData = $request->validate([
            'device_finger_print' => ['required'],
            'device_id' => ['required'],
            'android_id' => ['required'],
            'username' => ['required'],
            'points' => ['required'],
            'level' => ['required'],
        ],
        [
            'device_finger_print.required' => 'Device Data is required',
            'device_id.required' => 'Device Id is required',
            'android_id.required' => 'Android Data is required',
            'username.required' => 'Username is required',
            'points.required' => 'Points is equired',
            'level.required' => 'Level are equired',
        ]);

        $searchLeaderboard = Leaderboard::Where('username', $request->username)
                                ->Where('category_id', $request->level)->first();
        if($searchLeaderboard !=null){
            if($request->points > $searchLeaderboard->points){
                $searchLeaderboard->points = $request->points;
                $searchLeaderboard->save();    
            }
            return $searchLeaderboard;
        }else{
            $leaderboard = new Leaderboard();
            $leaderboard->device_finger_print = $request->device_finger_print;
            $leaderboard->device_id = $request->device_id;
            $leaderboard->android_id = $request->android_id;
            $leaderboard->username = $request->username;
            $leaderboard->points = $request->points;
            $leaderboard->category_id = $request->level;
            $leaderboard->save();
            return $leaderboard;
        }
        
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function showGrades($id)
    {
        //
        $grades = Grade::has('subjects')->where('category_id', $id)->get();
        return $grades;
       
    }
    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function showSubjects($id)
    {
        //
        $subjects = Subject::has('questions')->where('category_id', $id)->get();
        return $subjects;
       
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function edit($id)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $id)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        //
    }
}
